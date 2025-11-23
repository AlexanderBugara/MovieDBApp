//
//  FeedMovieCellController.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import SwiftUI
import MoviesFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public struct FeedMovieCellController: CellDataSource {
    let id = UUID()
    private let viewModel: MoviePreviewModel
    private let delegate: FeedImageCellControllerDelegate
    public init(viewModel: MoviePreviewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func cell() -> AnyView {
        AnyView(MovieCell(model: viewModel, onAppear: {
            delegate.didRequestImage()
        }, onDissapear: {
            delegate.didCancelImageRequest()
        }))
    }
}
