//
//  MovieFeedView.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import Combine
import MoviesFeed

public struct MovieFeedView: View {
    @ObservedObject var model: FeedMovieViewModel
    @State private var toast: Toast?
    let cell: (MoviePreviewModel) -> MovieCell
    public var onRefresh: (() -> Void)?
    
    public init(
        cell: @escaping (MoviePreviewModel) -> MovieCell,
        model: FeedMovieViewModel,
        onRefresh: (() -> Void)?
    ) {
        self.cell = cell
        self.onRefresh = onRefresh
        self.model = model
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.moviesFeedUIState.feed, id: \.id) { movie in
                    MovieCell(model: movie)
                }
            }
        }
        .toast($toast)
        .onChange(of: model.moviesFeedUIState) { _, uiState in
            guard let errorMessage = uiState.errorMessage else {
                return
            }
            toast = Toast(message: errorMessage)
        }
        .padding()
        .task {
            onRefresh?()
        }
    }
}

#Preview {
    MovieFeedView(cell: { _ in
        MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
    }, model: FeedMovieViewModel(state: MoviesFeedUIState(
        feed: [
            MoviePreviewModel(title: "movie preview model title 1"),
            MoviePreviewModel(title: "movie preview model title 2"),
            MoviePreviewModel(title: "movie preview model title 3"),
            MoviePreviewModel(title: "movie preview model title 4")
        ],
        isLoading: false,
        errorMessage: "message")), onRefresh: {})
}
