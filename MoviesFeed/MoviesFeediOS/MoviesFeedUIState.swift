//
//  MoviesFeedUIState.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import Foundation
import MoviesFeed

public struct MoviesFeedUIState: Equatable {
    public let feed: [CellController]
    public let isLoading: Bool
    public let errorMessage: String?
    
    public init(feed: [CellController], isLoading: Bool, errorMessage: String?) {
        self.feed = feed
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
}
extension MoviesFeedUIState {
    public static var empty: MoviesFeedUIState {
        MoviesFeedUIState(feed: [], isLoading: false, errorMessage: nil)
    }
}
