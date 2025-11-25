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
    
    public func get(from request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        session
            .dataTaskPublisher(for: request)
            .tryMap { output -> (Data, HTTPURLResponse) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (output.data, httpResponse)
            }
            .eraseToAnyPublisher()
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
