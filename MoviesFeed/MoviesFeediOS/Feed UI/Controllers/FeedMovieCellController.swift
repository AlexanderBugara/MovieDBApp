//
//  FeedMovieCellController.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import SwiftUI
import MoviesFeed

public struct FeedMovieCellController: CellDataSource {
    let id = UUID()
    private let viewModel: MoviePreviewModel
    public init(viewModel: MoviePreviewModel) {
        self.viewModel = viewModel
    }
    
    public func cell() -> AnyView {
        AnyView(MovieCell(model: viewModel))
    }
}
