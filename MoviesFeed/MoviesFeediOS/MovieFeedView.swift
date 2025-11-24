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
    @State var query: String = ""

    @State private var hasAppeared = false
    
    public init(model: FeedMovieViewModel) {
        self.model = model
    }
    
    public var body: some View {
        TextField("Search movies...", text: $query)
            .padding()
            .textFieldStyle(.roundedBorder)
            .task(id: query) {
                if !hasAppeared {
                    hasAppeared = true
                    return
                }
                try? await Task.sleep(for: .milliseconds(350))
                guard !query.isEmpty else {
                    model.loadFeed()
                    return
                }
                model.search(text: query)
            }
        
        ScrollView {
            LazyVStack {
                ForEach(model.moviesFeedUIState.feed, id: \.id) { controller in
                    controller.dataSource.cell()
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
            model.loadFeed()
        }
    }
}

//#Preview {
//    MovieFeedView(cell: { _ in
//        MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
//    }, model: FeedMovieViewModel(state: MoviesFeedUIState(
//        feed: [
//            MoviePreviewModel(title: "movie preview model title 1"),
//            MoviePreviewModel(title: "movie preview model title 2"),
//            MoviePreviewModel(title: "movie preview model title 3"),
//            MoviePreviewModel(title: "movie preview model title 4")
//        ],
//        isLoading: false,
//        errorMessage: "message")), onRefresh: {})
//}
