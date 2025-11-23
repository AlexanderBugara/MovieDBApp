//
//  MovieItem.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation

public struct FeedMovie: Hashable {
    public let id: Int
    public let name: String
    public let url: URL
    
    public init(id: Int, name: String, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
public struct FeedMoviePage: Hashable {
    public let index: Int
    public let total: Int
    public let feed: [FeedMovie]

    public init(index: Int, total: Int, feed: [FeedMovie]) {
        self.index = index
        self.total = total
        self.feed = feed
    }
}
