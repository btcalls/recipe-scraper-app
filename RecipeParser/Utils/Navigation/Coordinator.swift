//
//  Coordinator.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 18/12/2025.
//

import Foundation
import SwiftUI

enum AppPages: Hashable {
    case onboarding
    case home
    case recipes
    case recipe(Recipe)
    
    var title: String {
        switch self {
        case .onboarding: ""
        case .home: .yourRecipes
        case .recipes: .allRecipes
        case .recipe(_): ""
        }
    }
}

enum Sheet: Identifiable {
    var id: UUID {
        UUID()
    }
    
    case browser
    case instructions([DetailedInstruction], @MainActor () -> Void)
}

final class Coordinator: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var sheet: Sheet?
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .onboarding:
            OnboardingView()
        
        case .home:
            HomeView()
        
        case .recipes:
            RecipeListView(view: .full)
        
        case .recipe(let item):
            RecipeView(item)
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .browser:
            BrowserView()
                .ignoresSafeArea()
        
        case let .instructions(items, action):
            InstructionsView(items: items) {
                action()
            }
        }
    }
}
