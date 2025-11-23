//
//  FeedViewSearchAdapter.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation
import MoviesFeed
import MoviesFeediOS
import SwiftUI

final class FeedViewSearchAdapter: ResourceView {
    private weak var viewModel: FeedMovieViewModel?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedMovie) -> Void
    private let currentFeed: [FeedMovie: CellController]
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MoviePreviewModel>, Void>
    
    init(currentFeed: [FeedMovie: CellController] = [:],
         viewModel: FeedMovieViewModel,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
         selection: @escaping (FeedMovie) -> Void) {
        self.currentFeed = currentFeed
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ feed: [FeedMovie]) {
        guard let viewModel = viewModel else { return }
        
        var currentFeed = self.currentFeed
        
        let feed: [CellController] = feed.compactMap { [weak self] model in
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
        
        viewModel.display(feed)
    }
}
