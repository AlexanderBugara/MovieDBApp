//
//  FeedRequest.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import Foundation

public struct FeedRequest {
    private init() {}
    
    public static func makeAuthorizedRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(bearer)"
        ]
        return request
    }
    
    private static var bearer: String {
        ProcessInfo.processInfo.environment["bearer"] ?? ""
    }
}

