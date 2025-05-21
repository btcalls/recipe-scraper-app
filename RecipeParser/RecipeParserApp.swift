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
//    @State private var isOnboardingComplete
    var body: some Scene {
        WindowGroup {
            if AppSettings.shared.isOnboardingComplete {
                HomeView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(.shared)
    }
}
