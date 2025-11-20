//
//  HTTPClient.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import Foundation
import Combine

public protocol HTTPClient {
    func get(from request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}
