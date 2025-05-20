//
//  RecipeParserApp.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

@main
struct RecipeParserApp: App {
    var body: some Scene {
        WindowGroup {
//            OnboardingView()
//            ParseRecipeView(url: URL(string: "https://www.recipetineats.com/crispy-oven-baked-quesadillas/")!)
            HomeView()
        }
        .modelContainer(.shared)
    }
}
