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
        errorMessage: nil)
    
}

public struct MovieFeedView: View {
    @StateObject var model: MovieFeedViewModel
    
    public init() {
        self._model = StateObject(wrappedValue: MovieFeedViewModel())
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.moviesFeedUIState.feed, id: \.id) {_ in 
                    MovieCell()
                }
            }
        }
        .padding()
    }
}

#Preview {
    MovieFeedView()
}
