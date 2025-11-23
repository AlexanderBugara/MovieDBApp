//
//  Query.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation

public struct Query {
    public let page: Int
    public let text: String
    public init(page: Int, text: String) {
        self.page = page
        self.text = text
    }
}
