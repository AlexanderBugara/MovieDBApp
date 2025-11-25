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
        private let page: Int
        
        private struct RemoteFeedItem: Decodable {
            let id: Int
            let title: String
            let posterPath: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case title
                case posterPath = "poster_path"
            }
        }
        
        func page(_ imageBaseURL: URL) -> FeedMoviePage {
            
            let movies = results.compactMap { result -> FeedMovie? in
                guard let path = result.posterPath else {
                    return nil
                }
                return FeedMovie(
                    movieId: result.id,
                    name: result.title,
                    url: ImageEndpoint
                        .get(path)
                        .url(baseURL: imageBaseURL)
                )
            }
            return FeedMoviePage(index: page, total: total_pages, feed: movies)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse,  baseImageURL: URL) throws -> FeedMoviePage {
        guard isOK(response) else {
            throw Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        let page = root.page(baseImageURL)
        return page
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
