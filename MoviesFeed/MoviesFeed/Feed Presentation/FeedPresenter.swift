//
//  FeedPresenter.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import Foundation

public final class FeedPresenter {
    private init() {}
    public static var searchPlaceholder: String {
        NSLocalizedString("SEARCH_MOVIE",
            tableName: "Feed",
            bundle: Bundle(for: Self.self),
            comment: "Placeholder for searching")
    }
}
