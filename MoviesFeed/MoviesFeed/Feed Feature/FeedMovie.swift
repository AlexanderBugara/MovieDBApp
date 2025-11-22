//
//  MovieItem.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation

public struct FeedMovie: Hashable {
    public let id: Int
    public let name: String
    public let posterPath: String
    
    public init(id: Int, name: String, posterPath: String) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
    }
}

public struct MoviePage {
    public let totalPages: Int
    public let totalElements: Int
    public let movies: [FeedMovie]
}
