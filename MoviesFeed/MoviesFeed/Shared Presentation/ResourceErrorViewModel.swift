//
//  ResourceErrorViewModel.swift
//  MoviesFeed
//
//  Created by Oleksandr Buhara on 11/22/25.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
