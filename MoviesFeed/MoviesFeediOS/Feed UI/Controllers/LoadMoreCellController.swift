//
//  LoadMoreCellController.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import SwiftUI
import MoviesFeed

public final class LoadMoreViewModel: ObservableObject {
    public enum UIState: Equatable {
        case loading
        case errorMessage(String)
        case idle
    }
    @Published public var state: UIState
    public init(state: UIState = .idle) {
        self.state = state
    }
}

public class LoadMoreCellController: CellDataSource {
    let id = UUID()
    private let cellViewModel: LoadMoreViewModel
    private let callback: () -> Void
    public init(cellViewModel: LoadMoreViewModel, callback: @escaping () -> Void) {
        self.cellViewModel = cellViewModel
        self.callback = callback
    }
    
    public func cell() -> AnyView {
        AnyView(LoadMoreCell(
            model: cellViewModel, 
            loadMore: { [weak self] in
                guard let self = self else {
                    return
                }
                if cellViewModel.state == .loading {
                    return
                }
                self.callback()
            })
        )
    }
}

extension LoadMoreViewModel: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        guard let errorMessage = viewModel.message else {
            return
        }
        state = .errorMessage(errorMessage)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        state = viewModel.isLoading ? .loading : .idle
    }
}
