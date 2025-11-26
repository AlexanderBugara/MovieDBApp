//
//  SearchModellable.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import Foundation

public protocol FeedSearchable: AnyObject {
    func serch(_ text: String)
    func refresh()
}
