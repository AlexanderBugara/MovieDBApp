//
//  MovieDetailsEndpoint.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation

public enum MovieDetailsEndpoint {
    case get(id: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/3/movie/\(id)"
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "language", value: "en-US")
            ].compactMap { $0 }
            return components.url!
        }
    }
    
    private var apiKey: String? {
        ProcessInfo.processInfo.environment["TMDB_API_KEY"]
    }
}
