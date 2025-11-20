//
//  MoviePreviewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import Foundation

public struct MoviePreviewModel {
    public let id = UUID()
    public let title: String
    public init(title: String) {
        self.title = title
    }
}
