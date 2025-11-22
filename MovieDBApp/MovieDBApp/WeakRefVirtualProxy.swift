//
//  WeakRefVirtualProxy.swift
//  MovieDBApp
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import SwiftUI
import MoviesFeed

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == Image {
    func display(_ model: Image) {
        object?.display(model)
    }
}
