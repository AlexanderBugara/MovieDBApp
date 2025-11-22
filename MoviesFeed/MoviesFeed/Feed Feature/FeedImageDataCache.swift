//
//  FeedImageDataCache.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
