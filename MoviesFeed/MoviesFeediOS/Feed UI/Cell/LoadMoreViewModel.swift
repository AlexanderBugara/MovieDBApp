//
//  LoadMoreViewModel.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation
import MoviesFeed

public final class LoadMoreViewModel: ObservableObject {
    public enum UIState: Equatable {
        case loading
        case error(String)
        case idle
    }
    @Published public var state: UIState
    public init(state: UIState = .idle) {
        self.state = state
    }
}

extension LoadMoreViewModel: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        guard let message = viewModel.message else {
            state = .idle
            return
        }
        state = .error(message)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        state = viewModel.isLoading ? .loading : .idle
    }
}
