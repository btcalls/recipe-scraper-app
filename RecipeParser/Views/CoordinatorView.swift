//
//  CoordinatorView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 23/12/2025.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    private var rootPage: AppPages {
        if AppValues.shared.isOnboardingComplete {
            return .home
        }
        
        return .onboarding
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: rootPage)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                        .navigationTitle(page.title)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.buildSheet(sheet: sheet)
                }
        }
        .environmentObject(coordinator)
    }
}
