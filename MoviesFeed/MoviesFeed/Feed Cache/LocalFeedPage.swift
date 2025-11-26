//
//  LocalFeedPage.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation

public struct LocalFeedPage: Equatable {
    public let index: Int
    public let total: Int
    public let feed: [LocalFeedMovie]
    
    public init(index: Int, total: Int, feed: [LocalFeedMovie]) {
        self.index = index
        self.total = total
        self.feed = feed
    }
}
