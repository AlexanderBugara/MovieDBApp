//
//  FeedViewAdapter.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import SwiftUI
import MoviesFeed

final class FeedViewAdapter: ResourceView {
    private weak var viewModel: FeedMovieViewModel?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedMovie) -> Void
    private let imageURL: (FeedMovie) -> URL
    private let currentFeed: [FeedMovie: MoviePreviewModel]
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MoviePreviewModel>>
    
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMovie>, FeedViewAdapter>
    
    init(currentFeed: [FeedMovie: MoviePreviewModel] = [:], 
         imageURL: @escaping (FeedMovie) -> URL,
         viewModel: FeedMovieViewModel,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
         selection: @escaping (FeedMovie) -> Void) {
        self.currentFeed = currentFeed
        self.imageURL = imageURL
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ page: Paginated<FeedMovie>) {
        guard let viewModel = viewModel else { return }
        
        var currentFeed = self.currentFeed
        let feed: [MoviePreviewModel] = page.items.compactMap { [weak self] model in
            guard let self = self else {
                return nil
            }
            if let preview = currentFeed[model] {
                return preview
            }
            
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(self.imageURL(model))
            })
            
            let preview = MoviePreviewModel(title: model.name)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(preview),
                loadingView: WeakRefVirtualProxy(viewModel),
                errorView: WeakRefVirtualProxy(viewModel),
                mapper: Image.tryMake)
            
            currentFeed[model] = preview
            return preview
        }
        
        guard let loadMorePublisher = page.loadMorePublisher else {
            viewModel.display(feed)
            return
        }
        
        viewModel.display(feed)
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
    public func display(_ resourceModel: Image) {
        
    }
    
    public typealias ResourceViewModel = Image
    
    
}

extension FeedMovieViewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        
    }
}

extension FeedMovieViewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        
    }
}
