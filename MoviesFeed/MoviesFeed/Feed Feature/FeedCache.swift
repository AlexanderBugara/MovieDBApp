//
//  FeedCache.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedMovie]) throws
}
