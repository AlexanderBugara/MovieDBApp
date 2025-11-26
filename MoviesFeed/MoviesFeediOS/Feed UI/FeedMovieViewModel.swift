//
//  FeedMovieViewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation
import MoviesFeed
import Combine

public class FeedMovieViewModel: ObservableObject {
    @Published public var moviesFeedUIState: MoviesFeedUIState
    private(set) public var onAppear: ((Void?) -> Void)?
    private(set) public var onRefresh: ((Void?) -> Void)?
    private(set) public var onPerformSearch: ((Query) -> Void)?
    
    public init(state: MoviesFeedUIState = MoviesFeedUIState.empty,
                onRefresh: ((Void?) -> Void)?,
                onPerformSearch: ((Query) -> Void)?) {
        self.moviesFeedUIState = state
        self.onPerformSearch = onPerformSearch
        self.onRefresh = onRefresh
        self.onAppear = onRefresh
    }
    
    public func display(_ controllers: [CellController]) {
        moviesFeedUIState = MoviesFeedUIState(
            feed: controllers,
            isLoading: false,
            errorMessage: nil)
    }
    
    func appear() {
        onAppear?(())
        onAppear = nil
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
            feed: moviesFeedUIState.feed,
            isLoading: false,
            errorMessage: viewModel.message)
        
    }
}

extension FeedMovieViewModel: FeedSearchable {
    public func serch(_ text: String) {
        onPerformSearch?(Query(page: 1, text: text))
    }
    
    public func refresh() {
        onRefresh?(())
    }
}
