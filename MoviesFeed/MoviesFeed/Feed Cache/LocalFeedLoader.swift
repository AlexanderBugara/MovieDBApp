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
    public func save(_ page: FeedMoviePage) throws {
        try store.deleteCachedFeed()
        try store.insert(page.toLocal())
    }
}

extension LocalFeedLoader {
    public func load() throws -> FeedMoviePage {
        if let page = try store.retrieve() {
            return page.toModel()
        }
        return FeedMoviePage(index: 0, total: 0, feed: [])
    }
}

private extension Array where Element == FeedMovie {
    func toLocal() -> [LocalFeedMovie] {
        return map { 
            LocalFeedMovie(movieId: $0.movieId, name: $0.name, url: $0.url)
        }
    }
}

private extension Array where Element == LocalFeedMovie {
    func toModels() -> [FeedMovie] {
        return map {
            return FeedMovie(movieId: $0.movieId, name: $0.name ?? "", url: $0.url)
        }
    }
}

private extension FeedMoviePage {
    func toLocal() -> LocalFeedPage {
        LocalFeedPage(index: index, total: total, feed: feed.toLocal())
    }
}
private extension LocalFeedPage {
    func toModel() -> FeedMoviePage {
        FeedMoviePage(index: index, total: total, feed: feed.toModels())
    }
}
