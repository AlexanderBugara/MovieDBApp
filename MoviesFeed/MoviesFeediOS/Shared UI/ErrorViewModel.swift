//
//  ErrorViewModel.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/25/25.
//

import Foundation

@MainActor
class ErrorViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    
    func showError(_ msg: String?) {
        errorMessage = msg
        
        Task {
            try? await Task.sleep(for: .seconds(3))
            if errorMessage == msg {
                errorMessage = nil
            }
        }
    }
    
    func dismiss() {
        errorMessage = nil
    }
}
