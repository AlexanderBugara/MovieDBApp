//
//  MovieDetailAdapter.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import SwiftUI
import MoviesFeed
import MoviesFeediOS

final class MovieDetailAdapter: ResourceView {
    typealias ResourceViewModel = MovieDetail
    
    private weak var viewModel: MovieDetailViewViewModel?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<MovieDetailViewModel>, Void>
    
    init(viewModel: MovieDetailViewViewModel,
         imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }

    
    func display(_ detail: MovieDetail) {
        guard let viewModel = viewModel else { return }
        
        let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] _ in
            imageLoader(detail.url ?? URL(string: "http://google.com")!)
        })
        
        let detailViewModel = MovieDetailViewModel(
            id: detail.id,
            title: detail.title,
            overview: detail.overview,
            releaseDate: detail.releaseDate,
            voteAverage: detail.voteAverage)
        
        let movieDetailController = MovieDetailsController(
            viewModel: detailViewModel,
            delegate: adapter)
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(detailViewModel),
            loadingView: WeakRefVirtualProxy(detailViewModel),
            errorView: WeakRefVirtualProxy(detailViewModel),
            mapper: Image.tryMake)
        viewModel.display(CellController(id: UUID(), movieDetailController))
    }
}


