//
//  LoadMoreCell.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import MoviesFeed

public struct LoadMoreCell: View {
    @ObservedObject private var model: LoadMoreViewModel
    private let loadMore: () -> Void
    public init(model: LoadMoreViewModel, loadMore: @escaping () -> Void) {
        self.model = model
        self.loadMore = loadMore
    }
    public var body: some View {
        Group {
            switch model.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                
            case let .errorMessage(message):
                Text(message)
            case .idle:
                Text(" ").task {
                    loadMore()
                }
            }
        }
    }
}

#Preview {
    MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
}
