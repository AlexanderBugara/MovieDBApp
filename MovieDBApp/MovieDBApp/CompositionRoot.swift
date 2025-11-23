//
//  CompositionRoot.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import SwiftUI
import MoviesFeed
import MoviesFeediOS
import Combine

private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMoviePage>, FeedViewAdapter>

class CompositionRoot {
    let itemsPerPage = 20
    
    private func adapter() -> FeedPresentationAdapter {
        FeedPresentationAdapter(loader: self.makeRemoteFeedLoaderWithLocalFallback)
    }
    
    private let scheduler = DispatchQueue(label: "com.db.movie", qos: .userInitiated)
    private lazy var store: FeedStore & FeedImageDataStore = InMemoryFeedStore()
    
    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    private lazy var baseImageURL = URL(string: "https://image.tmdb.org")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store)
    }()
    
    func makeFeedView() -> MovieFeedView {
        let presenterAdapter = FeedPresentationAdapter(loader: { [unowned self] in
            self.makeRemoteFeedLoaderWithLocalFallback()
        })
        let viewModel = FeedMovieViewModel()
        presenterAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                viewModel: viewModel,
                imageLoader: self.makeLocalImageLoaderWithRemoteFallback,
                selection: {_ in}),
            loadingView: WeakRefVirtualProxy(viewModel),
            errorView: WeakRefVirtualProxy(viewModel))
                                                       
        return MovieFeedView(
            model: viewModel,
            onRefresh: presenterAdapter.loadResource)
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedMoviePage>, Error> {
        makeRemoteFeedLoader(page: 1)
            .receive(on: scheduler)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map(makeFirstPage)
            .eraseToAnyPublisher()
    }
    
    func makeRemoteLoadMoreLoader(page: Int) -> AnyPublisher<Paginated<FeedMoviePage>, Error> {
        localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(page: page))
            .map { (cachedPage, newPage) in
                FeedMoviePage(index: newPage.index, total: newPage.total, feed: cachedPage.feed + newPage.feed)
            }
            .map(makePage)
            .receive(on: scheduler)
            .caching(to: localFeedLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(page: Int) -> AnyPublisher<FeedMoviePage, Error> {
        let url = FeedEndpoint.get(index: page).url(baseURL: baseURL)
        
        return httpClient
            .get(from: FeedRequest.makeAuthorizedRequest(url: url))
            .map { [unowned self] result in
                (result.0, result.1, self.baseImageURL)
            }
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(page: FeedMoviePage) -> Paginated<FeedMoviePage> {
        makePage(page: page)
    }
    
    private func makePage(page: FeedMoviePage) -> Paginated<FeedMoviePage> {
        Paginated(item: page, loadMorePublisher: { [unowned self] in
            self.makeRemoteLoadMoreLoader(page: page.index + 1)
        })
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient, scheduler] in
                httpClient
                    .get(from: FeedRequest.makeAuthorizedRequest(url: url))
                    .tryMap(FeedMovieDataMapper.map)
                    .receive(on: scheduler)
                    .caching(to: localImageLoader, using: url)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
