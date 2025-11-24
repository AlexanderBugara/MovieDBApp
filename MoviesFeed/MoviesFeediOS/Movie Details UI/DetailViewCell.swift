//
//  DetailViewCell.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/24/25.
//

import SwiftUI
import MoviesFeed

struct DetailViewCell: View {
    @ObservedObject var model: MovieDetailViewModel
    let onAppear: () -> Void
    let onDissapear: () -> Void
    
    public var body: some View {
        content(model)
            .onAppear {
                onAppear()
            }.onDisappear {
                onDissapear()
            }
    }
    
    private func content(_ model: MovieDetailViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                switch model.uiState {
                case .image(let image):
                    AnyView(
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(8)
                    )
                case .imageLoading:
                    AnyView(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding(24)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    )
                    
                case .failed:
                    AnyView(
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
                    )
                    
                case .idle:
                    AnyView(
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(2/3, contentMode: .fit)
                    )
                }
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(model.title)
                            .font(.title)
                            .bold()
                        if let released = model.releaseDate, !released.isEmpty {
                            Text(released)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    ratingView(vote: model.voteAverage)
                }
                
                if let overview = model.overview, !overview.isEmpty {
                    Text("Overview")
                        .font(.headline)
                    Text(overview)
                        .font(.body)
                }
                Spacer()
            }
            .padding()
        }
    }
    
    
    private func ratingView(vote: Double?) -> some View {
        VStack {
            Text(vote.map { String(format: "%.1f", $0) } ?? "—")
                .font(.title2)
                .bold()
            Text("Rating")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
    }
}
