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
            CoordinatorView()
        }
        .environment(appSettings)
        .modelContainer(.shared())
    }
}
