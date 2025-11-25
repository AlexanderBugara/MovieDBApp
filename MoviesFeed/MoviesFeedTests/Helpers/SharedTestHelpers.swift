//
//  SharedTestHelpers.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]], totalPages: Int, totalItems: Int, page: Int) -> Data {
    let json = ["results": items, 
                "total_pages": totalPages,
                "total_results": totalItems,
                "page": page] as [String : Any]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
