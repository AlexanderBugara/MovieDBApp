//
//  CanNotLoadFeedError.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import Foundation
import MoviesFeed

struct CanNotLoadFeedError: Error {}

struct IfEmpyThenError {
    static func verify(_ page: FeedMoviePage) throws -> FeedMoviePage {
        guard !page.feed.isEmpty else {
            throw CanNotLoadFeedError()
        }
        return page
        
    }
}
