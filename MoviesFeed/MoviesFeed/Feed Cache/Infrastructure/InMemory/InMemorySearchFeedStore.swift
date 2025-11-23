//
//  InMemoryFeedStore.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public class InMemorySearchFeedStore {
    private var feedCache: LocalFeedPage?
    private var feedImageDataCache = NSCache<NSURL, NSData>()
    
    public init() {}
}

extension InMemorySearchFeedStore: FeedStore {
    public func deleteCachedFeed() throws {
        feedCache = nil
    }

    public func insert(_ page: LocalFeedPage) throws {
        feedCache = page
    }

    public func retrieve() throws -> LocalFeedPage? {
        feedCache
    }
}

extension InMemorySearchFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL) throws {
        feedImageDataCache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        feedImageDataCache.object(forKey: url as NSURL) as Data?
    }
}
