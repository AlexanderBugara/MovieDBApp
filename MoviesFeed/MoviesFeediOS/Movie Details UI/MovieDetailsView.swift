//
//  MovieDetailsView.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import SwiftUI
import MoviesFeed
import Combine

private func localPlaceholderImage() -> UIImage? {
    return UIImage(contentsOfFile: "")
}

public struct MovieDetailView: View {
    @ObservedObject private var model: MovieDetailViewViewModel
    
    public init(model: MovieDetailViewViewModel) {
        self.model = model
    }

    public var body: some View {
        ScrollView {
            if model.state.isLoading {
                loadingView
            } else if !model.state.isLoading, let cellController = model.state.cellController {
                cellController.dataSource.cell()
            } else if let error = model.state.errorMessage {
                errorView(error)
            } else {
                emptyView
            }
        }
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { 
            model.appear()
        }
        .refreshable {
            model.refresh()
        }
    }

    private var loadingView: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            ProgressView().scaleEffect(1.5)
        }
    }

    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private var emptyView: some View {
        VStack { Text("No data") }
    }
}
