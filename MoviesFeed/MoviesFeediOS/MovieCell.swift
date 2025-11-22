//
//  MovieCell.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import MoviesFeed

public struct MovieCell: View {
    private let model: MoviePreviewModel
    public init(model: MoviePreviewModel) {
        self.model = model
    }
    public var body: some View {
        Text(model.title)
    }
}

#Preview {
    MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
}
