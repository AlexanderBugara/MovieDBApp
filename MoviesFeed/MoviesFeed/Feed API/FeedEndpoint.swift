//
//  FeedEndpoint.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/19/25.
//

import Foundation

public enum FeedEndpoint {
    case get(after: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/3/movie/now_playing"
            components.queryItems = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1")
            ].compactMap { $0 }
            return components.url!
        }
    }
    
    private var apiKey: String? {
        ProcessInfo.processInfo.environment["TMDB_API_KEY"]
    }
}
