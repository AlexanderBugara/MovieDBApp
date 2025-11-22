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
        private let total_pages: Int
        private let total_results: Int
        
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
        
        private var movies: [FeedMovie] {
            results.map { FeedMovie(
                id: $0.id,
                name: $0.title, 
                posterPath: $0.posterPath ?? "")
            }
        }
        
        var page: MoviePage {
            MoviePage(
                totalPages: total_pages,
                totalElements: total_results,
                movies: movies)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> MoviePage {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.page
    }
}
