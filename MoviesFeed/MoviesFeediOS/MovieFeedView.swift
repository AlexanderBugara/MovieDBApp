//
//  MovieFeedView.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import Combine
import MoviesFeed

class MovieFeedViewModel: ObservableObject {
    @Published var moviesFeedUIState: MoviesFeedUIState = MoviesFeedUIState(
        feed: [
            MoviePreviewModel(title: "movie preview model title 1"),
            MoviePreviewModel(title: "movie preview model title 2"),
            MoviePreviewModel(title: "movie preview model title 3"),
            MoviePreviewModel(title: "movie preview model title 4")
        ],
        isLoading: false,
        errorMessage: "message")
}

public struct MovieFeedView: View {
    @StateObject var model: MovieFeedViewModel
    @State private var toast: Toast?
    let cell: (MoviePreviewModel) -> MovieCell
    public init(cell: @escaping (MoviePreviewModel) -> MovieCell) {
        self.cell = cell
        self._model = StateObject(wrappedValue: MovieFeedViewModel())
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
            model.moviesFeedUIState = MoviesFeedUIState(
                feed: [
                    MoviePreviewModel(title: "movie preview model title 1"),
                    MoviePreviewModel(title: "movie preview model title 2"),
                    MoviePreviewModel(title: "movie preview model title 3"),
                    MoviePreviewModel(title: "movie preview model title 4")
                ],
                isLoading: false,
                errorMessage: "message")
        }
    }
}

#Preview {
    MovieFeedView(cell: { _ in
        MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
    })
}
