//
//  MovieCell.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import MoviesFeed

public struct MovieCell: View {
    @ObservedObject private var model: MoviePreviewModel
    let onAppear: () -> Void
    let onDissapear: () -> Void
    
    public init(
        model: MoviePreviewModel,
        onAppear: @escaping () -> Void = {},
        onDissapear: @escaping () -> Void = {}) {
            self.model = model
            self.onAppear = onAppear
            self.onDissapear = onDissapear
        }
    
    public var body: some View {
        HStack {
            switch model.uiState {
            case let .image(image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(8)
                    .clipped()
            case .imageLoading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            case .failed:
                Button(action: onAppear) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            case .idle:
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
            }
            Text(model.title)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.horizontal)
        }.onAppear {
            onAppear()
        }.onDisappear {
            onDissapear()
        }
    }
}

#Preview {
    MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
}
