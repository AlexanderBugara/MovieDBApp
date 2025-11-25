//
//  MoviePreviewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import MoviesFeed

public class MoviePreviewModel: ObservableObject {
    public enum UIState {
        case image(Image)
        case imageLoading
        case failed
        case idle
    }
    public let id = UUID()
    public let title: String
    @Published public var uiState: UIState
    public init(title: String, uiState: UIState = .idle) {
        self.title = title
        self.uiState = uiState
    }
    
    public static func == (lhs: MoviePreviewModel, rhs: MoviePreviewModel) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

extension MoviePreviewModel: ResourceView {
    public typealias ResourceViewModel = Image
    public func display(_ resourceModel: ResourceViewModel) {
        uiState = .image(resourceModel)
    }
}
extension MoviePreviewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        uiState = viewModel.isLoading ? .imageLoading : .idle
    }
}
extension MoviePreviewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        uiState = .failed
    }
}
