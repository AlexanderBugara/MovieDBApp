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
            let overview: String
            let posterPath: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case title
                case overview
                case posterPath = "poster_path"
            }
        }
        
        func page(url: URL) -> FeedMoviePage {
            
            let movies = results.compactMap { result -> FeedMovie? in
                guard
                    let poster = result.posterPath
                else {
                    return nil
                }

                return FeedMovie(
                    movieId: result.id,
                    name: result.title,
                    url: ImageEndpoint
                        .get(poster)
                        .url(baseURL: url)
                )
            }
            return FeedMoviePage(index: page, total: total_pages, feed: movies)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse,  baseImageURL: URL) throws -> FeedMoviePage {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        let page = root.page(url: baseImageURL)
        print(">>>>> page == \(page.index) total: \(page.total) feed: \(page.feed.count)")
        return page
    }
}
