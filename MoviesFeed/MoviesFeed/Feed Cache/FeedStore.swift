//
//  FeedStore.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedMovie]) throws
    func retrieve() throws -> [LocalFeedMovie]?
}
