//
//  SearchContext.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/6/2025.
//

import Foundation

final class SearchContext: ObservableObject {
    @Published var query = ""
    @Published var debouncedQuery = ""
    
    init(delayFor seconds: TimeInterval = 0.5) {
        $query
            .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .assign(to: &$debouncedQuery)
    }
}
