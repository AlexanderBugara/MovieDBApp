//
//  FeedEndpointTests.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import XCTest
import MoviesFeed

final class FeedEndpointTests: XCTestCase {
    func test_movies_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let received = FeedEndpoint.get(index: 1).url(baseURL: baseURL)
        
        let expected = URL(string: "http://base-url.com/3/movie/now_playing?language=en-US&page=1")!
        
        XCTAssertEqual(received, expected)
    }
    
    
    
}
