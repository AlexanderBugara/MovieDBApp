//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import XCTest
import MoviesFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
	func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
	}
	
	func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
	}
}
