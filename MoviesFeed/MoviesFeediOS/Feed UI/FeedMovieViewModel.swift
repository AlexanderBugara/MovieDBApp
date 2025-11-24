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
    
    func search(text: String) {
        onPerformSearch?(Query(page: 1, text: text))
    }
    
    func appear() {
        onAppear?(())
        onAppear = nil
    }
    
    func refresh() {
        onRefresh?(())
    }
}
