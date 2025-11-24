//
//  MovieDetailsController.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation
import MoviesFeed
import SwiftUI

public struct MovieDetailsController: CellDataSource {
    private let viewModel: MovieDetailViewModel
    private let delegate: FeedImageCellControllerDelegate
    public init(
        viewModel: MovieDetailViewModel,
        delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func cell() -> AnyView {
        AnyView(
            DetailViewCell(model: viewModel, onAppear: {
                delegate.didRequestImage()
            }, onDissapear: {
                delegate.didCancelImageRequest()
            })
        )
    }
}
