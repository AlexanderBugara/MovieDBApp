//
//  LocalFeedLoader.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    
    public init(store: FeedStore) {
        self.store = store
    }
}

extension LocalFeedLoader: FeedCache {
    public func save(_ feed: [FeedMovie]) throws {
        try store.deleteCachedFeed()
        try store.insert(feed.toLocal())
    }
}

extension LocalFeedLoader {
    public func load() throws -> [FeedMovie] {
        if let feed = try store.retrieve() {
            return feed.toModels()
        }
        return []
    }
}

private extension Array where Element == FeedMovie {
    func toLocal() -> [LocalFeedMovie] {
        return map { 
            LocalFeedMovie(id: $0.id, name: $0.name, posterPath: $0.posterPath)
        }
    }
}

private extension Array where Element == LocalFeedMovie {
    func toModels() -> [FeedMovie] {
        return map { 
            FeedMovie(id: $0.id, name: $0.name ?? "", posterPath: $0.posterPath)
        }
    }
}
