//
//  FeedMapperTests.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import XCTest
import MoviesFeed

final class FeedItemsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJSON([], totalPages: 0, totalItems: 0, page: 0)
        let samples = [199, 150, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code), baseImageURL: URL(string: "http://image.base.com")!)
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code), baseImageURL: URL(string: "http://image.base.com")!)
            )
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([], totalPages: 0, totalItems: 0, page: 0)
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code), baseImageURL: URL(string: "http://image.base.com")!)
            XCTAssertEqual(result, FeedMoviePage.empty)
        }
    }
    
    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(movieId: 12, name: "any name", url: URL(string: "http://image.base.com/t/p/w200/path_to_image")!)
        
        let item2 = makeItem(movieId: 13, name: "any name 1", url: URL(string: "http://image.base.com/t/p/w200/path_to_image_1")!)
        
        let json = makeItemsJSON([item1.json, item2.json], totalPages: 1, totalItems: 2, page: 1)
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code), baseImageURL: URL(string: "http://image.base.com")!)
            
            XCTAssertEqual(result.index, 1)
            XCTAssertEqual(result.total, 1)
            
            XCTAssertEqual(result.feed.first?.movieId, item1.model.movieId)
            XCTAssertEqual(result.feed.first?.name, item1.model.name)
            XCTAssertEqual(result.feed.first?.url, item1.model.url)
            
            XCTAssertEqual(result.feed.last?.movieId, item2.model.movieId)
            XCTAssertEqual(result.feed.last?.name, item2.model.name)
            XCTAssertEqual(result.feed.last?.url, item2.model.url)
        }
    }
    
    // MARK: - Helpers
    
    private func makeItem(movieId: Int, name: String, url: URL) -> (model: FeedMovie, json: [String: Any]) {
        let item = FeedMovie(
            movieId: movieId,
            name: name,
            url: url)
        
        let json: [String: Any] = [
            "id": movieId,
            "title": name,
            "poster_path": "/" + url.lastPathComponent
        ]
        
        return (item, json)
    }
    
}
