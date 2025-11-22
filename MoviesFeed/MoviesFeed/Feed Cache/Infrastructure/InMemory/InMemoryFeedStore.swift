//
//  InMemoryFeedStore.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public class InMemoryFeedStore {
    private var feedCache: [LocalFeedMovie]?
    private var feedImageDataCache = NSCache<NSURL, NSData>()
    
    public init() {}
}

extension InMemoryFeedStore: FeedStore {
    public func deleteCachedFeed() throws {
        feedCache = nil
    }

    public func insert(_ feed: [LocalFeedMovie]) throws {
        feedCache = feed
    }

    public func retrieve() throws -> [LocalFeedMovie]? {
        feedCache
    }
}

extension InMemoryFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL) throws {
        feedImageDataCache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        feedImageDataCache.object(forKey: url as NSURL) as Data?
    }
}
