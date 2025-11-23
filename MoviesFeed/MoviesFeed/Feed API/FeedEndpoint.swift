//
//  FeedEndpoint.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/19/25.
//

import Foundation

public enum FeedEndpoint {
    case get(index: Int)
    case search(query: Query)
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(index):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/3/movie/now_playing"
            components.queryItems = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(index)")
            ].compactMap { $0 }
            return components.url!
        case .search(query: let query):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/3/search/movie"
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "query", value: query.text),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(query.page)")
            ].compactMap { $0 }
            
            return components.url!
        }
    }
    
    private var apiKey: String? {
        ProcessInfo.processInfo.environment["TMDB_API_KEY"]
    }
}
