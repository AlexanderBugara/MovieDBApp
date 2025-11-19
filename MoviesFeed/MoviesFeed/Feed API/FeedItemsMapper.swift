//
//  FeedItemsMapper.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation

public final class FeedItemsMapper {
    private struct Root: Decodable {
        private let results: [RemoteFeedItem]

        private struct RemoteFeedItem: Decodable {
            let id: Int
            let title: String
            let overview: String
            let posterPath: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case title
                case overview
                case posterPath = "poster_path"
            }
        }
        
        var movies: [MovieItem] {
            results.map { MovieItem(id: $0.id, title: $0.title) }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [MovieItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.movies
    }
}
