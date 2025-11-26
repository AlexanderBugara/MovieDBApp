//
//  FeedCacheTestHelpers.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import Foundation
import MoviesFeed

func uniqueMovie1() -> FeedMovie {
    return FeedMovie(movieId: 1, name: "any 1", url: URL(string: "http://any-url-1.com")!)
}
func uniqueMovie2() -> FeedMovie {
	return FeedMovie(movieId: 2, name: "any 2", url: URL(string: "http://any-url-2.com")!)
}

func uniqueMoviePage() -> (model: FeedMoviePage, local: LocalFeedPage) {
	let model = FeedMoviePage(index: 1, total: 2, feed: [uniqueMovie1(), uniqueMovie2()])
    let local = LocalFeedPage(index: model.index, total: model.total, feed: model.feed.map {
        LocalFeedMovie(movieId: $0.movieId, name: $0.name, url: $0.url)
    })
    return (model, local)
}
