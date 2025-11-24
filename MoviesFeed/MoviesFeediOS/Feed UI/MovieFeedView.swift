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
    @State var query: String = ""
    @State private var previousQuery: String = ""
    @State private var hasAppeared = false
    
    public init(model: FeedMovieViewModel) {
        self.model = model
    }
    
    public var body: some View {
        TextField("Search movies...", text: $query)
            .overlay(
                    HStack {
                        Spacer()
                        if !query.isEmpty {
                            Button {
                                query = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
            .padding(.horizontal)
            .textFieldStyle(.roundedBorder)
            .task(id: query) {
                if !hasAppeared {
                    hasAppeared = true
                    return
                }
                let oldValue = previousQuery
                previousQuery = query
                
                try? await Task.sleep(for: .milliseconds(350))
                if query.isEmpty && !oldValue.isEmpty {
                    previousQuery = ""
                    model.refresh()
                    return
                } else if !query.isEmpty && query != oldValue {
                    model.search(text: query)
                }
            }
        
        ScrollView {
            LazyVStack {
                ForEach(model.moviesFeedUIState.feed, id: \.id) { controller in
                    controller.dataSource.cell()
                }
            }
        }
        .padding()
        .task {
            model.appear()
        }
        .refreshable {
            model.refresh()
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
