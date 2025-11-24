//
//  MovieDetailViewViewModel.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation
import MoviesFeed

public final class MovieDetailViewViewModel: ObservableObject {
    private var onAppear: ((Int?) -> Void)?
    private var onRefresh: ((Int?) -> Void)?
    @Published private(set) var state: MovieDetailsUIState
    let title: String
    private let feedMovie: FeedMovie
    public init(feedMovie: FeedMovie, onAppear: ((Int?) -> Void)?) {
        self.feedMovie = feedMovie
        self.onRefresh = onAppear
        self.title = feedMovie.name
        self.onAppear = onAppear
        self.state = MovieDetailsUIState.empty
    }
    
    func appear() {
        onAppear?(feedMovie.movieId)
        onAppear = nil
    }
    func refresh() {
        onRefresh?(feedMovie.movieId)
    }
    public func display(_ cellController: CellController) {
        state = MovieDetailsUIState(
            cellController: cellController,
            errorMessage: nil,
            isLoading: false
        )
    }
}
extension MovieDetailViewViewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        state = MovieDetailsUIState(
            cellController: nil,
            errorMessage: nil,
            isLoading: viewModel.isLoading
        )
    }
}
extension MovieDetailViewViewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        state = MovieDetailsUIState(
            cellController: nil,
            errorMessage: viewModel.message,
            isLoading: false
        )
    }
}
