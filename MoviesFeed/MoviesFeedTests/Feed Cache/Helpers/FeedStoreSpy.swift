//
//  FeedStoreSpy.swift
//  MoviesFeedTests
//
//  Created by Oleksandr Buhara on 11/25/25.
//
import Foundation
import MoviesFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
		case deleteCachedFeed
		case insert(LocalFeedPage)
		case retrieve
	}
	
	private(set) var receivedMessages = [ReceivedMessage]()
	
	private var deletionResult: Result<Void, Error>?
	private var insertionResult: Result<Void, Error>?
	private var retrievalResult: Result<LocalFeedPage?, Error>?
	
	func deleteCachedFeed() throws {
		receivedMessages.append(.deleteCachedFeed)
		try deletionResult?.get()
	}
	
	func completeDeletion(with error: Error) {
		deletionResult = .failure(error)
	}
	
	func completeDeletionSuccessfully() {
		deletionResult = .success(())
	}
	
    func insert(_ page: MoviesFeed.LocalFeedPage) throws {
		receivedMessages.append(.insert(page))
		try insertionResult?.get()
	}
	
	func completeInsertion(with error: Error) {
		insertionResult = .failure(error)
	}
	
	func completeInsertionSuccessfully() {
		insertionResult = .success(())
	}
	
	func retrieve() throws -> LocalFeedPage? {
		receivedMessages.append(.retrieve)
		return try retrievalResult?.get()
	}
	
	func completeRetrieval(with error: Error) {
		retrievalResult = .failure(error)
	}
	
	func completeRetrievalWithEmptyCache() {
		retrievalResult = .success(.none)
	}
	
	func completeRetrieval(with page: LocalFeedPage) {
		retrievalResult = .success(page)
	}
}
