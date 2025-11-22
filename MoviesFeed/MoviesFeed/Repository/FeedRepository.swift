//
//  FeedRepository.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

struct PageViewModel {
    let index: Int
}

protocol FeedRepository {
    func load(after: PageViewModel)
}
