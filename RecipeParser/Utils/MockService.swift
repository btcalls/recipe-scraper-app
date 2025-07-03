//
//  MockService.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import Foundation
import SwiftData

final class MockService {
    private struct Recipes: Decodable {
        let data: [Recipe]
    }
    
    static let shared = MockService()
    
    let imageURL = URL(string: "https://www.recipetineats.com/tachyon/2024/07/Baked-Beef-Quasadillas-51259.jpg")!
    let recipeURL = URL(string: "https://www.recipetineats.com/crispy-oven-baked-quesadillas/")!
    
    /// Get a single `Recipe` instance from sample data.
    /// - Returns: `Recipe` sample instance.
    func getRecipe() -> Recipe {
        let recipes = getRecipes()
        
        if !recipes.isEmpty {
            return recipes[0]
        }
        
        return .init(
            id: "asdf-dfd",
            name: "Homemade Burger",
            image: "https://realfood.tesco.com/media/images/1400x919HawaiianBurger-39059ab5-b8bb-4147-b927-70fc1a88bfc5-0-1400x919.jpg",
            categories: [.init("Main"), .init("Afternoon Tea")],
            cuisines: [.init("American"), .init("Pacific")],
            detail: "Tasty burger",
            prepTime: 20,
            totalTime: 40,
            instructions: [""],
            ingredients: [.init(base: "bun", amount: "2", label: "2 bun")],
            label: "",
            isFavorite: false
        )
    }
    
    /// Decode list of `Recipe` instances from `sample_data.json` file.
    /// - Returns: `Recipe` list if a valid JSON file was parsed, else and empty array.
    func getRecipes() -> [Recipe] {
        let path = Bundle.main.path(forResource: "sample_data", ofType: "json")
        
        guard let path, let data = try? Data(
            contentsOf: URL(filePath: path),
            options: .mappedIfSafe
        ) else {
            return []
        }
        
        guard let decoded = try? JSONDecoder.standard.decode(Recipes.self, from: data) else {
            return []
        }
        
        return decoded.data
    }
    
    /// Configures a `ModelContainer` which can be used globally to mock storage with sample data in memory.
    /// - Parameter withSample: Flag whether to populate data or not.
    /// - Returns: Configured `ModelContainer` similar to the one used in app.
    @MainActor
    func modelContainer(withSample: Bool = true) -> ModelContainer {
        let modelConfiguration = ModelConfiguration(schema: ModelContainer.schema,
                                                    isStoredInMemoryOnly: true,
                                                    groupContainer: .identifier(.extensionGroup))
        
        do {
            let container = try ModelContainer(for: ModelContainer.schema,
                                               configurations: [modelConfiguration])
            
            if withSample {
                for recipe in MockService.shared.getRecipes() {
                    // Randomise isFavorite
                    recipe.isFavorite = .random()
                    
                    container.mainContext.insert(recipe)
                }
            }
            
            return container
        } catch {
            fatalError("Failed to create mock ModelContainer: \(error)")
        }
    }
}
