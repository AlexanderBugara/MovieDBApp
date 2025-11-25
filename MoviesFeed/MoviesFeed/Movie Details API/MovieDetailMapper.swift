//
//  MovieDetailMapper.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation

public final class MovieDetailMapper {
    private struct RemoteMovieDetail: Decodable, Identifiable {
        public let id: Int
        public let title: String
        public let overview: String?
        public let releaseDate: String?
        public let voteAverage: Double?
        public let posterPath: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case overview
            case releaseDate = "release_date"
            case posterPath = "poster_path"
            case voteAverage = "vote_average"
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse,  baseImageURL: URL) throws -> MovieDetail {
        guard response.isOK, let detail = try? JSONDecoder().decode(RemoteMovieDetail.self, from: data) else {
            throw Error.invalidData
        }
        return MovieDetail(
            id: detail.id,
            title: detail.title,
            overview: detail.overview,
            releaseDate: detail.releaseDate,
            voteAverage: detail.voteAverage,
            url: ImageEndpoint
                .get(detail.posterPath)
                .url(baseURL: baseImageURL, size: .w500))
    }
}
