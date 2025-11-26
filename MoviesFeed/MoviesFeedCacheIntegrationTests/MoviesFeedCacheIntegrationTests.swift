//
//  MoviesFeedCacheIntegrationTests.swift
//  MoviesFeedCacheIntegrationTests
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import XCTest
import MoviesFeed

final class MoviesFeedCacheIntegrationTests: XCTestCase {
    
    // MARK: - LocalFeedLoader Tests
    
    func test_loadFeed_deliversNoItemsOnEmptyCache() throws {
        let feedLoader = try makeFeedLoader(store: InMemoryFeedStore())
        
        expect(feedLoader, toLoad: FeedMoviePage.empty)
    }
    
    func test_loadFeed_deliversItemsSavedOnASeparateInstance() throws {
        let store = InMemoryFeedStore()
        let feedLoaderToPerformSave = try makeFeedLoader(store: store)
        let feedLoaderToPerformLoad = try makeFeedLoader(store: store)
        let feed = uniqueMoviePage().model
        
        save(feed, with: feedLoaderToPerformSave)
        
        expect(feedLoaderToPerformLoad, toLoad: feed)
    }
    
    func test_saveFeed_overridesItemsSavedOnASeparateInstance() throws {
        let store = InMemoryFeedStore()
        let feedLoaderToPerformFirstSave = try makeFeedLoader(store: store)
        let feedLoaderToPerformLastSave = try makeFeedLoader(store: store)
        let feedLoaderToPerformLoad = try makeFeedLoader(store: store)
        let firstFeed = uniqueMoviePage().model
        let latestFeed = uniqueMoviePage().model
        
        save(firstFeed, with: feedLoaderToPerformFirstSave)
        save(latestFeed, with: feedLoaderToPerformLastSave)
        
        expect(feedLoaderToPerformLoad, toLoad: latestFeed)
    }
    
    // MARK: - LocalFeedImageDataLoader Tests
    
    func test_loadImageData_deliversSavedDataOnASeparateInstance() throws {
        let store = InMemoryFeedStore()
        let imageLoaderToPerformSave = try makeImageLoader(store: store)
        let imageLoaderToPerformLoad = try makeImageLoader(store: store)
        let feedLoader = try makeFeedLoader(store: store)
        let movie = uniqueMovie1()
        let page = uniqueMoviePage()
        let dataToSave = anyData()
        
        save(page.model, with: feedLoader)
        save(dataToSave, for: movie.url, with: imageLoaderToPerformSave)
        
        expect(imageLoaderToPerformLoad, toLoad: dataToSave, for: movie.url)
    }
    
    func test_saveImageData_overridesSavedImageDataOnASeparateInstance() throws {
        let store = InMemoryFeedStore()
        let imageLoaderToPerformFirstSave = try makeImageLoader(store: store)
        let imageLoaderToPerformLastSave = try makeImageLoader(store: store)
        let imageLoaderToPerformLoad = try makeImageLoader(store: store)
        let feedLoader = try makeFeedLoader(store: store)
        let page = uniqueMoviePage()
        let firstImageData = Data("first".utf8)
        let lastImageData = Data("last".utf8)
        let movie = uniqueMovie1()
        
        save(page.model, with: feedLoader)
        save(firstImageData, for: movie.url, with: imageLoaderToPerformFirstSave)
        save(lastImageData, for: movie.url, with: imageLoaderToPerformLastSave)
        
        expect(imageLoaderToPerformLoad, toLoad: lastImageData, for: movie.url)
    }
    
    // MARK: - Helpers
    
    private func makeFeedLoader(store: InMemoryFeedStore, file: StaticString = #filePath, line: UInt = #line) throws -> LocalFeedLoader {
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeImageLoader(store: InMemoryFeedStore, file: StaticString = #filePath, line: UInt = #line) throws -> LocalFeedImageDataLoader {
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func save(_ feed: FeedMoviePage, with loader: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.save(feed)
        } catch {
            XCTFail("Expected to save feed successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: FeedMoviePage, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedFeed = try sut.load()
            XCTAssertEqual(loadedFeed.index, expectedFeed.index, file: file, line: line)
            XCTAssertEqual(loadedFeed.total, expectedFeed.total, file: file, line: line)
            for (expected, loaded) in zip(expectedFeed.feed, loadedFeed.feed) {
                XCTAssertEqual(expected.movieId, loaded.movieId, file: file, line: line)
                XCTAssertEqual(expected.name, loaded.name, file: file, line: line)
                XCTAssertEqual(expected.url, loaded.url, file: file, line: line)
            }
        } catch {
            XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
        }
    }
    
    private func save(_ data: Data, for url: URL, with loader: LocalFeedImageDataLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.save(data, for: url)
        } catch {
            XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toLoad expectedData: Data, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedData = try sut.loadImageData(from: url)
            XCTAssertEqual(loadedData, expectedData, file: file, line: line)
        } catch {
            XCTFail("Expected successful image data result, got \(error) instead", file: file, line: line)
        }
    }
}

