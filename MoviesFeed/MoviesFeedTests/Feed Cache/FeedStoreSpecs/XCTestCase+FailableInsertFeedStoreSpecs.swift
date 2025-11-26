//
//  XCTestCase+FailableInsertFeedStoreSpecs
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import XCTest
import MoviesFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
	func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let insertionError = insert(uniqueMoviePage().local, to: sut)
		
		XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
	}
	
	func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		insert(uniqueMoviePage().local, to: sut)
		
		expect(sut, toRetrieve: .success(.none), file: file, line: line)
	}
}
