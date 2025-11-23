//
//  CellController.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/23/25.
//

import Foundation
import SwiftUI

public protocol CellDataSource {
    func cell() -> AnyView
}

public struct CellController {
    let id: AnyHashable
    let dataSource: any CellDataSource
    
    public init(id: AnyHashable, _ dataSource: any CellDataSource) {
        self.id = id
        self.dataSource = dataSource
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
