//
//  MoviesFeedUIState.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import Foundation

public struct MoviesFeedUIState {
    public let feed: [MoviePreviewModel]
    public let isLoading: Bool
    public let errorMessage: String?
    
    public init(feed: [MoviePreviewModel], isLoading: Bool, errorMessage: String?) {
        self.feed = feed
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
}
