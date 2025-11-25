//
//  HTTPClient.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation
import Combine

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
