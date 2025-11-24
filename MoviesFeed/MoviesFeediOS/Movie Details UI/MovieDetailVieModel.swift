//
//  MovieDetailVieModel.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import SwiftUI
import MoviesFeed

public class MovieDetailViewModel: ObservableObject {
    public enum UIState {
        case image(Image)
        case imageLoading
        case failed(String)
        case idle
    }
    
    public let id: Int
    public let title: String
    public let overview: String?
    public let releaseDate: String?
    public let voteAverage: Double?
    @Published var uiState: UIState = .idle
    
    public init(id: Int, title: String, overview: String?, releaseDate: String?, voteAverage: Double?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}
extension MovieDetailViewModel: ResourceView {
    public typealias ResourceViewModel = Image
    public func display(_ resourceModel: ResourceViewModel) {
        uiState = .image(resourceModel)
    }
}
extension MovieDetailViewModel: ResourceErrorView {
    public func display(_ viewModel: MoviesFeed.ResourceErrorViewModel) {
        guard let errorMessage = viewModel.message else {
            uiState = .idle
            return
        }
        uiState = .failed(errorMessage)
    }
}
extension MovieDetailViewModel: ResourceLoadingView {
    public func display(_ viewModel: MoviesFeed.ResourceLoadingViewModel) {
        uiState = viewModel.isLoading ? .imageLoading : .idle
    }
}
