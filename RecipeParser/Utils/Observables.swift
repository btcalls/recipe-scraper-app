//
//  Observables.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import SwiftUI

@Observable
final class AppSettings {
    enum RootView {
        case onboarding
        case home
    }
    
    var rootView: RootView = .onboarding
}

@Observable
final class ViewState {
    var isProcessing = false
    var toast: ToastView.State?
}

final class SearchContext: ObservableObject {
    @Published var query = ""
    @Published var debouncedQuery = ""
    
    init(delayFor seconds: TimeInterval = 0.5) {
        $query
            .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .assign(to: &$debouncedQuery)
    }
}
