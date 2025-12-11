//
//  View+BottomError.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import SwiftUI

extension View {
    func bottomError(message: String?, onDismiss: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            if let message = message {
                VStack {
                    Spacer()
                    BottomErrorView(message: message, onDismiss: onDismiss)
                }
            }
        }
    }
}
