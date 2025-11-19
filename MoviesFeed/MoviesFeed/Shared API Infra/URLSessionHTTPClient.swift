//
//  URLSessionHTTPClient.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation
import Combine

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        session.dataTaskPublisher(for: url)
            .tryMap { output -> (Data, HTTPURLResponse) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (output.data, httpResponse)
            }
            .eraseToAnyPublisher()
    }
}
