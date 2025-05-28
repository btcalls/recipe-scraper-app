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
    @State private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            if AppValues.shared.isOnboardingComplete {
                HomeView()
            } else {
                switch appSettings.rootView {
                case .onboarding:
                    OnboardingView()
                    
                case .home:
                    HomeView()
                        .transition(.opacity.animation(.bouncy(duration: 0.5)))
                }
            }
        }
        .environment(appSettings)
        .modelContainer(.shared())
    }
}
