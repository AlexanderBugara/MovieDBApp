//
//  LoadMoreViewModel.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation

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
