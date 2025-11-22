//
//  LocalFeedMovie.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public struct LocalFeedMovie {
    public let id: Int
    public let name: String?
    public let posterPath: String
    
    public init(id: Int, name: String?, posterPath: String) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
    }
}
