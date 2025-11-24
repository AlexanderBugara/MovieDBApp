//
//  MovieDetailsUIState.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import Foundation

struct MovieDetailsUIState {
    let cellController: CellController?
    let errorMessage: String?
    let isLoading: Bool
}
extension MovieDetailsUIState {
    static var empty: MovieDetailsUIState {
        MovieDetailsUIState(cellController: nil, errorMessage: nil, isLoading: false)
    }
}
