//
//  XCTestCase+FeedStoreSpecs.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import XCTest
import MoviesFeed

extension FeedStoreSpecs where Self: XCTestCase {
	
	func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieve: .success(.none), file: file, line: line)
	}
	
	func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
	}
	
	func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let localPage = uniqueMoviePage().local
		
		insert(localPage, to: sut)
		
		expect(sut, toRetrieve: .success(localPage), file: file, line: line)
	}
	
	func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let localPage = uniqueMoviePage().local
		
		insert(localPage, to: sut)
		
		expect(sut, toRetrieveTwice: .success(localPage), file: file, line: line)
	}
	
	func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let insertionError = insert(uniqueMoviePage().local, to: sut)
		
		XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
	}
	
	func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		insert(uniqueMoviePage().local, to: sut)
		
		let insertionError = insert(uniqueMoviePage().local, to: sut)
		
		XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
	}
	
	func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		insert(uniqueMoviePage().local, to: sut)
		
		let localPage = uniqueMoviePage().local
		insert(localPage, to: sut)
		
		expect(sut, toRetrieve: .success(localPage), file: file, line: line)
	}
	
	func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		let deletionError = deleteCache(from: sut)
		
		XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
	}
	
	func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		deleteCache(from: sut)
		
		expect(sut, toRetrieve: .success(.none), file: file, line: line)
	}
	
	func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		insert(uniqueMoviePage().local, to: sut)
		
		let deletionError = deleteCache(from: sut)
		
		XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
	}
	
	func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
		insert(uniqueMoviePage().local, to: sut)
		
		deleteCache(from: sut)
		
		expect(sut, toRetrieve: .success(.none), file: file, line: line)
	}
	
}

extension FeedStoreSpecs where Self: XCTestCase {
	@discardableResult
	func insert(_ cache: LocalFeedPage, to sut: FeedStore) -> Error? {
		do {
			try sut.insert(cache)
			return nil
		} catch {
			return error
		}
	}
	
	@discardableResult
	func deleteCache(from sut: FeedStore) -> Error? {
		do {
			try sut.deleteCachedFeed()
			return nil
		} catch {
			return error
		}
	}
	
	func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: Result<LocalFeedPage?, Error>, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieve: expectedResult, file: file, line: line)
		expect(sut, toRetrieve: expectedResult, file: file, line: line)
	}
	
	func expect(_ sut: FeedStore, toRetrieve expectedResult: Result<LocalFeedPage?, Error>, file: StaticString = #filePath, line: UInt = #line) {
		let retrievedResult = Result { try sut.retrieve() }
		
		switch (expectedResult, retrievedResult) {
		case (.success(.none), .success(.none)),
			 (.failure, .failure):
			break
			
		case let (.success(.some(expected)), .success(.some(retrieved))):
			XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
            XCTAssertEqual(retrieved.index, expected.index, file: file, line: line)
            XCTAssertEqual(retrieved.total, expected.total, file: file, line: line)
			
		default:
			XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
		}
	}
}
