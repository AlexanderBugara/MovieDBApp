//
//  MovieItem.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation

public struct MovieItem: Hashable {
    public let id: Int
    public let title: String
    
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
