//
//  LoadFeedFromCacheUseCaseTests.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import XCTest
import MoviesFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
	
	func test_init_doesNotMessageStoreUponCreation() {
		let (_, store) = makeSUT()
		
		XCTAssertEqual(store.receivedMessages, [])
	}
	
	func test_load_requestsCacheRetrieval() {
		let (sut, store) = makeSUT()
		
		_ = try? sut.load()
		
		XCTAssertEqual(store.receivedMessages, [.retrieve])
	}
	
	func test_load_failsOnRetrievalError() {
		let (sut, store) = makeSUT()
		let retrievalError = anyNSError()
		
		expect(sut, toCompleteWith: .failure(retrievalError), when: {
			store.completeRetrieval(with: retrievalError)
		})
	}
	
	func test_load_deliversNoMoviesOnEmptyCache() {
		let (sut, store) = makeSUT()
		
        expect(sut, toCompleteWith: .success(FeedMoviePage.empty), when: {
			store.completeRetrievalWithEmptyCache()
		})
	}
	
	func test_load_hasNoSideEffectsOnRetrievalError() {
		let (sut, store) = makeSUT()
		store.completeRetrieval(with: anyNSError())
		
		_ = try? sut.load()
		
		XCTAssertEqual(store.receivedMessages, [.retrieve])
	}
	
	func test_load_hasNoSideEffectsOnEmptyCache() {
		let (sut, store) = makeSUT()
		store.completeRetrievalWithEmptyCache()
		
		_ = try? sut.load()
		
		XCTAssertEqual(store.receivedMessages, [.retrieve])
	}
	
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
		let store = FeedStoreSpy()
		let sut = LocalFeedLoader(store: store)
		trackForMemoryLeaks(store, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, store)
	}
	
	private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: Result<FeedMoviePage, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		action()

		let receivedResult = Result { try sut.load() }
		
		switch (receivedResult, expectedResult) {
		case let (.success(receivedMovies), .success(expectedMovies)):
			XCTAssertEqual(receivedMovies, expectedMovies, file: file, line: line)
			
		case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
			XCTAssertEqual(receivedError, expectedError, file: file, line: line)
			
		default:
			XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
		}
	}
	
}
