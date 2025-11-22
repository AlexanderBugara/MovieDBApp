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

private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedMovie>, FeedViewAdapter>

class CompositionRoot {
    private func adapter() -> FeedPresentationAdapter {
        FeedPresentationAdapter(loader: self.makeRemoteLoadMoreLoader)
    }
    
    private let scheduler = DispatchQueue(label: "com.db.movie", qos: .userInitiated)
    private lazy var store: FeedStore & FeedImageDataStore = InMemoryFeedStore()
    
    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store)
    }()
    
    func makeFeedView() -> MovieFeedView {
        let presenterAdapter = FeedPresentationAdapter(loader: { [unowned self] in
            self.makeRemoteLoadMoreLoader()
        })
        let viewModel = FeedMovieViewModel()
        presenterAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                imageURL: { feedMovie in
                    ImageEndpoint.get(
                        feedMovie.posterPath
                    ).url(baseURL: self.baseURL)
                },
                viewModel: viewModel,
                imageLoader: self.makeLocalImageLoaderWithRemoteFallback,
                selection: {_ in}),
            loadingView: WeakRefVirtualProxy(viewModel),
            errorView: WeakRefVirtualProxy(viewModel))
                                                       
        return MovieFeedView(
            cell: { movieVieModel in
                MovieCell(model: movieVieModel)
            }, model: viewModel,
            onRefresh: presenterAdapter.loadResource
        )
    }
    
    func makeRemoteLoadMoreLoader(/*last: FeedMovie?*/) -> AnyPublisher<Paginated<FeedMovie>, Error> {
        localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(after: nil))
            .map { (cachedItems, newPage) in
                (cachedItems + newPage.movies)
            }
            .map(makePage)
            .receive(on: scheduler)
            .caching(to: localFeedLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(after: FeedMovie? = nil) -> AnyPublisher<MoviePage, Error> {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        
        return httpClient
            .get(from: FeedRequest.makeAuthorizedRequest(url: url))
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [FeedMovie]) -> Paginated<FeedMovie> {
        makePage(items: items)
    }
    
    private func makePage(items: [FeedMovie]) -> Paginated<FeedMovie> {
        Paginated(items: items, loadMorePublisher: items.last.map { last in
            { self.makeRemoteLoadMoreLoader(/*last: last*/) }
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
