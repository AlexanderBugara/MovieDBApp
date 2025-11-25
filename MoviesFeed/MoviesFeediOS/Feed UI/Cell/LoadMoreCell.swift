//
//  LoadMoreCell.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/20/25.
//

import SwiftUI
import MoviesFeed

public struct LoadMoreCell: View {
    @ObservedObject private var model: LoadMoreViewModel
    private let loadMore: () -> Void
    public init(model: LoadMoreViewModel, loadMore: @escaping () -> Void) {
        self.model = model
        self.loadMore = loadMore
    }
    public var body: some View {
        Group {
            switch model.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            case .idle:
                Text(" ").task {
                    loadMore()
                }
            case let .error(message):
                HStack {
                    Text(message)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Button(action: loadMore) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                            
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: message)

                
            }
        }
    }
}

#Preview {
    MovieCell(model: MoviePreviewModel(title: "movie preview model title 1"))
}
