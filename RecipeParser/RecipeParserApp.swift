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
                    .tint(.accentColor)
            } else {
                switch appSettings.rootView {
                case .onboarding:
                    OnboardingView()
                        .tint(.accentColor)
                    
                case .home:
                    HomeView()
                        .tint(.accentColor)
                        .transition(
                            .opacity.animation(.customInteractiveSpring)
                        )
                }
            }
        }
        .environment(appSettings)
        .modelContainer(.shared())
    }
}
