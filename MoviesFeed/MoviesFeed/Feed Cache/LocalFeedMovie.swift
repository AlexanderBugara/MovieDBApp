//
//  LocalFeedMovie.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public struct LocalFeedMovie {
    public let movieId: Int
    public let name: String?
    public let url: URL
    
    public init(movieId: Int, name: String?, url: URL) {
        self.movieId = movieId
        self.name = name
        self.url = url
    }
}
