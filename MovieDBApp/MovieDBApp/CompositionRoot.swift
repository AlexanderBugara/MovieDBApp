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

private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMoviePage>, FeedViewAdapter, Void>

private typealias FeedSearchPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMoviePage>, FeedViewAdapter, Query>

private typealias DetailsPresentationAdapter = LoadResourcePresentationAdapter<MovieDetail, MovieDetailAdapter, Int>

class CompositionRoot {
    let itemsPerPage = 20
    
    private func adapter() -> FeedPresentationAdapter {
        FeedPresentationAdapter(loader: self.makeRemoteFeedLoaderWithLocalFallback)
    }
    
    private let scheduler = DispatchQueue(label: "com.db.movie", qos: .userInitiated)
    private lazy var store: FeedStore & FeedImageDataStore = InMemoryFeedStore()
    private lazy var searchStorage: FeedStore & FeedImageDataStore = InMemoryFeedStore()
    
    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    private lazy var baseImageURL = URL(string: "https://image.tmdb.org")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store)
    }()
    
    private lazy var localFeedSearchLoader: LocalFeedLoader = {
        LocalFeedLoader(store: searchStorage)
    }()
    
    func makeFeedView() -> MovieFeedView {
        let presenterAdapter = FeedPresentationAdapter(loader: {_ in
            self.makeRemoteFeedLoaderWithLocalFallback(())
        })
        let searchAdapter = FeedSearchPresentationAdapter(loader: { query in
            self.makeRemoteSearchLoader(query: query)
        })
        
        let viewModel = FeedMovieViewModel(
            onRefresh: presenterAdapter.loadResource,
            onPerformSearch: searchAdapter.loadResource)
        
        let presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                viewModel: viewModel,
                imageLoader: self.makeLocalImageLoaderWithRemoteFallback,
                selection: {_ in}),
            loadingView: WeakRefVirtualProxy(viewModel),
            errorView: WeakRefVirtualProxy(viewModel))
        
        presenterAdapter.presenter = presenter
        searchAdapter.presenter = presenter
        
        return MovieFeedView(model: viewModel)
    }
    
    func makeDetailsView(feedModel: FeedMovie) -> MovieDetailView {
        let presenterAdapter = DetailsPresentationAdapter(loader: { movieId in
            self.makeRemoteDetailLoader(movieId: movieId)
        })
        
        let viewModel = MovieDetailViewViewModel(
            feedMovie: feedModel,
            onAppear: presenterAdapter.loadResource)
        
        let presenter = LoadResourcePresenter(
            resourceView: MovieDetailAdapter(
                viewModel: viewModel,
                imageLoader: self.makeLocalImageLoaderWithRemote),
            loadingView: WeakRefVirtualProxy(viewModel),
            errorView: WeakRefVirtualProxy(viewModel))
        
        presenterAdapter.presenter = presenter
        
        return MovieDetailView(model: viewModel)
    }
    
    private func makeRemoteDetailLoader(movieId: Int?) -> AnyPublisher<MovieDetail, Error> {
        let url = MovieDetailsEndpoint
            .get(id: movieId ?? -1)
            .url(baseURL: baseURL)
        
        return httpClient
            .get(from: FeedRequest.makeAuthorizedRequest(url: url))
            .tryMap { data, response in 
               try MovieDetailMapper.map(
                data,
                from: response,
                baseImageURL: self.baseImageURL) }
            .receive(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeLocalImageLoaderWithRemote(url: URL) -> FeedImageDataLoader.Publisher {
        return  httpClient
            .get(from: FeedRequest.makeAuthorizedRequest(url: url))
            .tryMap(FeedMovieDataMapper.map)
            .receive(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback(_ void: Void?) -> AnyPublisher<Paginated<FeedMoviePage>, Error> {
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
        Paginated(item: page, loadMorePublisher: { [unowned self] _ in
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

extension CompositionRoot {
    func makeRemoteSearchLoader(query: Query?) -> AnyPublisher<Paginated<FeedMoviePage>, Error> {
        try? searchStorage.deleteCachedFeed()
        return makeRemoteSearchFeedLoader(query: query)
            .receive(on: scheduler)
            .caching(to: localFeedSearchLoader)
            .map { [unowned self] page in self.makeSearchMorePage(page: page, query: query?.text ?? "") }
            .eraseToAnyPublisher()
    }
    
    func makeRemoteSearchMoreLoader(query: Query?) -> AnyPublisher<Paginated<FeedMoviePage>, Error> {
        return localFeedSearchLoader.loadPublisher()
            .zip(makeRemoteSearchFeedLoader(query: query))
            .map { (cachedPage, newPage) in
                (FeedMoviePage(
                    index: newPage.index,
                    total: newPage.total,
                    feed: cachedPage.feed + newPage.feed),
                 query?.text ?? "")
            }
            .map(makeSearchMorePage)
            .receive(on: scheduler)
            .caching(to: localFeedSearchLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteSearchFeedLoader(query: Query?) -> AnyPublisher<FeedMoviePage, Error> {
        guard let query = query else {
            return Just(FeedMoviePage.empty)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
        }
        let url = FeedEndpoint.search(query: query).url(baseURL: baseURL)
        
        return httpClient
            .get(from: FeedRequest.makeAuthorizedRequest(url: url))
            .map { [unowned self] result in
                (result.0, result.1, self.baseImageURL)
            }
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeSearchMorePage(page: FeedMoviePage, query: String) -> Paginated<FeedMoviePage> {
        Paginated(item: page, loadMorePublisher: { [unowned self] _ in
            self.makeRemoteSearchMoreLoader(query: Query(page: page.index + 1, text: query))
        })
    }
}
