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
    public let url: URL
    
    public init(id: Int, name: String?, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
