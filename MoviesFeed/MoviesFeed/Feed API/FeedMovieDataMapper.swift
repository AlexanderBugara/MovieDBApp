//
//  FeedMovieDataMapper.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public final class FeedMovieDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
