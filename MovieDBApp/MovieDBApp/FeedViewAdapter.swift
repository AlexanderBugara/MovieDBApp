//
//  FeedViewAdapter.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import SwiftUI
import MoviesFeed
import MoviesFeediOS
import Combine

final class FeedViewAdapter: ResourceView {
    private weak var viewModel: FeedMovieViewModel?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedMovie) -> Void
    private let currentFeed: [FeedMovie: CellController]
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MoviePreviewModel>, Void>
    
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMoviePage>, FeedViewAdapter, Void>
    
    init(currentFeed: [FeedMovie: CellController] = [:],
         viewModel: FeedMovieViewModel,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
         selection: @escaping (FeedMovie) -> Void) {
        self.currentFeed = currentFeed
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ page: Paginated<FeedMoviePage>) {
        guard let viewModel = viewModel else { return }
        
        var currentFeed = self.currentFeed
        
        let feed: [CellController] = page.item.feed.compactMap { [weak self] model in
            guard let self = self else {
                return nil
            }
            if let preview = currentFeed[model] {
                return preview
            }
            
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] _ in
                imageLoader(model.url)
            })
            
            let preview = MoviePreviewModel(title: model.name)
            
            let cellController = CellController(
                id: model,
                FeedMovieCellController(
                    viewModel: preview,
                    dto: model,
                    delegate: adapter
                )
            )
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(preview),
                loadingView: WeakRefVirtualProxy(preview),
                errorView: WeakRefVirtualProxy(preview),
                mapper: Image.tryMake)
            
            currentFeed[model] = cellController
            return cellController
        }
        
        guard let loadMorePublisher = page.loadMorePublisher else {
            viewModel.display(feed)
            return
        }
        
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        let loadMoreViewModel = LoadMoreViewModel()
        let loadMore = LoadMoreCellController(
            cellViewModel: loadMoreViewModel,
            callback: loadMoreAdapter.loadResource)
        
        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                currentFeed: currentFeed,
                viewModel: viewModel,
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(loadMoreViewModel),
            errorView: WeakRefVirtualProxy(loadMoreViewModel))
        if page.havingMore() {
            viewModel.display(feed + [CellController(id: UUID(), loadMore)])
        } else {
            viewModel.display(feed)
        }
    }
}

extension Image {
    struct InvalidImageData: Error {}
    
    static func tryMake(data: Data) throws -> Image {
        guard let uiImage = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return Image(uiImage: uiImage)
    }
}
extension MoviePreviewModel: ResourceView {
    public typealias ResourceViewModel = Image
    public func display(_ resourceModel: ResourceViewModel) {
        uiState = .image(resourceModel)
    }
}
extension MoviePreviewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        uiState = viewModel.isLoading ? .imageLoading : .idle
    }
}
extension MoviePreviewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        uiState = .failed
    }
}
extension FeedMovieViewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        self.moviesFeedUIState = .init(
            feed: [],
            isLoading: false, 
            errorMessage: nil)
    }
}

extension FeedMovieViewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        self.moviesFeedUIState = .init(
            feed: [],
            isLoading: false,
            errorMessage: viewModel.message)
    }
}

extension Paginated where Item == FeedMoviePage {
    func havingMore() -> Bool {
        item.index < item.total
    }
}
