//
//  MovieDBAppApp.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/18/25.
//

import SwiftUI
import MoviesFeed
import MoviesFeediOS
import Combine

@main
struct MovieDBAppApp: App {
    let compositionRoot = CompositionRoot()
    
    var body: some Scene {
        WindowGroup {
            compositionRoot.makeFeedView()
        }
    }
}
