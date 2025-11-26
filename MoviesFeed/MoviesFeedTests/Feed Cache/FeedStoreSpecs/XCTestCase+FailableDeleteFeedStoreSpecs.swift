//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import XCTest
import MoviesFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
	func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let deletionError = deleteCache(from: sut)
		
		XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
	}
	
	func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		deleteCache(from: sut)
		
		expect(sut, toRetrieve: .success(.none), file: file, line: line)
	}
}
