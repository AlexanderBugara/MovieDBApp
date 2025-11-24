//
//  ImageEndpoint.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public enum ImageEndpoint {
    public enum Size: String {
        case w500
        case w200
    }
    case get(String)

    public func url(baseURL: URL, size: Size = .w200) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/t/p/\(size.rawValue)\(id)")
        }
    }
}

