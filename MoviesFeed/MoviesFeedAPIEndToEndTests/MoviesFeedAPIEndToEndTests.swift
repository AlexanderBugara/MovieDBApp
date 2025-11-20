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
                receiveValue: { page in
                    XCTAssertFalse(page.movies.isEmpty, "Feed should not be empty")
                    XCTAssertEqual(page.movies.count, 20, "Expected 20 movies in the feed")
                }
            )
        
        wait(for: [expectation], timeout: 5)
    }
    
    private var feedTestServerURL: URL {
        return URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
    }
    
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> AnyPublisher<MoviePage, Error> {
        ephemeralClient()
            .get(from: FeedRequest.makeAuthorizedRequest(url: feedTestServerURL))
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

