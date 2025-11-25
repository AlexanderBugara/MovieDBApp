//
//  MovieDetail.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation

public struct MovieDetail {
    public let id: Int
    public let title: String
    public let overview: String?
    public let releaseDate: String?
    public let voteAverage: Double?
    public let url: URL
}
