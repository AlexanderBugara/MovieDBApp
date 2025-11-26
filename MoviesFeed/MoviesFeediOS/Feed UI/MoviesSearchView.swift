//
//  MoviesSearchView.swift
//  MoviesFeediOS
//
//  Created by Oleksandr Buhara on 11/26/25.
//

import Foundation
import MoviesFeed

public class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    
    private var previousQuery: String = ""
    private var searchTask: Task<Void, Never>? = nil
    private weak var searchDelegate: FeedSearchable?
    
    public init(searchDelegate: FeedSearchable?) {
        self.searchDelegate = searchDelegate
    }
    
    var placeholder: String {
        FeedPresenter.searchPlaceholder
    }
    
    func onQueryChanged() {
        searchTask?.cancel()
        
        let newQuery = query
        let oldQuery = previousQuery
        previousQuery = query
        
        searchTask = Task { [unowned self] in
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else { return }
            
            if newQuery.isEmpty && !oldQuery.isEmpty {
                previousQuery = ""
                searchDelegate?.refresh()
            } else if !newQuery.isEmpty && newQuery != oldQuery {
                searchDelegate?.serch(newQuery)
            }
        }
    }
    
    func clearQuery() {
        query = ""
    }
}
