//
//  CacheFeedUseCaseTests
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import XCTest
import MoviesFeed

class CacheFeedUseCaseTests: XCTestCase {
	
	func test_init_doesNotMessageStoreUponCreation() {
		let (_, store) = makeSUT()
		
		XCTAssertEqual(store.receivedMessages, [])
	}
	
	func test_save_doesNotRequestCacheInsertionOnDeletionError() {
		let (sut, store) = makeSUT()
		let deletionError = anyNSError()
		store.completeDeletion(with: deletionError)
		
		try? sut.save(uniqueMoviePage().model)
		
		XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
	}
	
	func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
		let page = uniqueMoviePage()
		let (sut, store) = makeSUT()
		store.completeDeletionSuccessfully()
		
        try? sut.save(page.model)
		
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(page.local)])
	}
	
	func test_save_failsOnDeletionError() {
		let (sut, store) = makeSUT()
		let deletionError = anyNSError()
		
		expect(sut, toCompleteWithError: deletionError, when: {
			store.completeDeletion(with: deletionError)
		})
	}
	
	func test_save_failsOnInsertionError() {
		let (sut, store) = makeSUT()
		let insertionError = anyNSError()
		
		expect(sut, toCompleteWithError: insertionError, when: {
			store.completeDeletionSuccessfully()
			store.completeInsertion(with: insertionError)
		})
	}
	
	func test_save_succeedsOnSuccessfulCacheInsertion() {
		let (sut, store) = makeSUT()
		
		expect(sut, toCompleteWithError: nil, when: {
			store.completeDeletionSuccessfully()
			store.completeInsertionSuccessfully()
		})
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
		let store = FeedStoreSpy()
		let sut = LocalFeedLoader(store: store)
		trackForMemoryLeaks(store, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, store)
	}
	
	private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		action()
		
		var receivedError: NSError?
		
		do {
			try sut.save(uniqueMoviePage().model)
		} catch {
			receivedError = error as NSError?
		}
		
		XCTAssertEqual(receivedError, expectedError, file: file, line: line)
	}
	
}
