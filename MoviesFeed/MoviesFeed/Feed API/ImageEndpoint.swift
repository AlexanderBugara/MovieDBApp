//
//  ImageEndpoint.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public enum ImageEndpoint {
    case get(String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/t/p/w200\(id)")
        }
    }
}

