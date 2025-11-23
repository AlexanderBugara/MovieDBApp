//
//  FeedMovieViewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation
import MoviesFeed

public class FeedMovieViewModel: ObservableObject {
    @Published public var moviesFeedUIState: MoviesFeedUIState
    
    public init(state: MoviesFeedUIState = MoviesFeedUIState(
        feed: [],
        isLoading: false,
        errorMessage: nil)) {
            self.moviesFeedUIState = state
        }
    
    func load() {
        
    }
    
    public func display(_ controllers: [CellController]) {
        moviesFeedUIState = MoviesFeedUIState(
            feed: controllers,
            isLoading: false,
            errorMessage: nil)
    }
}
