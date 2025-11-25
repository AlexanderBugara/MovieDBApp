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
    @StateObject private var errorViewModel = ErrorViewModel()
    
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
        .onChange(of: model.moviesFeedUIState, { oldValue, newValue in
            errorViewModel.showError(newValue.errorMessage)
        })
        .bottomError(message: errorViewModel.errorMessage) {
            errorViewModel.dismiss()
        }
        .task {
            model.appear()
        }
        .refreshable {
            model.refresh()
        }
    }
}

