//
//  MoviePreviewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import Foundation

public class MoviePreviewModel: Equatable {
    public let id = UUID()
    public let title: String
    public init(title: String) {
        self.title = title
    }
    
    public static func == (lhs: MoviePreviewModel, rhs: MoviePreviewModel) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}
