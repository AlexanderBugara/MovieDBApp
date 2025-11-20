//
//  Paginated.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/19/25.
//

import Foundation
import Combine

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMorePublisher: (() -> AnyPublisher<Self, Error>)?
    
    init(items: [Item], loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.items = items
        self.loadMorePublisher = loadMorePublisher
    }
}
