//
//  MoviesFeedAPIEndToEndTests.swift
//  MoviesFeedAPIEndToEndTests
//
//  Created by Oleksandr Buhara on 11/19/25.
//

import XCTest
import Combine
import MoviesFeed

final class MoviesFeedAPIEndToEndTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    func testExample() throws {
        let expectation = expectation(description: "Wait for feed result")
        
        cancellable = getFeedResult()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail("Request failed: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { movieFeed in
                    print("Received items: \(movieFeed)")
                    XCTAssertFalse(movieFeed.isEmpty, "Feed should not be empty")
                    XCTAssertEqual(movieFeed.count, 20, "Expected 20 movies in the feed")
                }
            )
        
        wait(for: [expectation], timeout: 5)
    }
    private var feedTestServerURL: URL {
        let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"]!
        return URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
    }
    
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> AnyPublisher<[MovieItem], Error> {
        ephemeralClient()
            .get(from: feedTestServerURL)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func ephemeralClient(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}

    extension XCTestCase {
        func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
            addTeardownBlock { [weak instance] in
                XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
            }
        }
    }

