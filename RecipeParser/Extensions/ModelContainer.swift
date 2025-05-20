//
//  ModelContainer.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 19/5/2025.
//

import SwiftData

extension ModelContainer {
    static var shared: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            Ingredient.self
        ])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false,
                                                    groupContainer: .identifier(.extensionGroup))
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
