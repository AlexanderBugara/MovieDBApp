//
//  MovieFeedRepository.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation
import Combine

final class MovieFeedRepository: FeedRepository {
    @Published private(set) var movieFeed: [MoviesFeedUIState] = []
    
    init() {
    }
    
    func load(after: PageViewModel) {
        
    }
}
