//
//  DetailPresentation.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import Foundation

public final class DetailPresentation {
    private init() {}
    public static var overview: String {
        NSLocalizedString("OVERVIEW",
            tableName: "FeedDetail",
            bundle: Bundle(for: Self.self),
            comment: "Label")
    }
    public static var raiting: String {
        NSLocalizedString("RATING",
            tableName: "FeedDetail",
            bundle: Bundle(for: Self.self),
            comment: "Label")
    }
}
