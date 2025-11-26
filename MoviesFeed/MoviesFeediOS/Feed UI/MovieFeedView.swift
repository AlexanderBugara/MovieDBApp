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
    @ObservedObject private var model: FeedMovieViewModel
    @StateObject private var errorViewModel = ErrorViewModel()
    @StateObject private var searchViewModel: SearchViewModel
    
    public init(model: FeedMovieViewModel,
         searchViewModel: SearchViewModel)  {
        self.model = model
        self._searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    public var body: some View {
        
        TextField(searchViewModel.placeholder, text: $searchViewModel.query)
            .overlay(
                HStack {
                    Spacer()
                    if !searchViewModel.query.isEmpty {
                        Button {
                            searchViewModel.clearQuery()
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
        
        ScrollView {
            LazyVStack {
                ForEach(model.moviesFeedUIState.feed, id: \.id) { controller in
                    controller.dataSource.cell()
                }
            }
        }
        .padding()
        .onChange(of: searchViewModel.query) {  _, _ in
            searchViewModel.onQueryChanged()
                    }
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

