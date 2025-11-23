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
    
    public let item: Item
    public let loadMorePublisher: (() -> AnyPublisher<Self, Error>)?
    
    public init(item: Item, loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.item = item
        self.loadMorePublisher = loadMorePublisher
    }
}
