//
//  XCTestCase+MemoryLeakTracking.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import Foundation

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
