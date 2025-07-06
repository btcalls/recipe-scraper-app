//
//  String.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import Foundation
import SwiftUI

extension String {
    // MARK: Buttons
    
    static let cancel = "Cancel"
    static let saveRecipe = "Save Recipe"
    static let getStarted = "Get Started"
    static let processing = "Processing..."
    static let parsingRecipe = "Parsing Recipe..."
    static let seeAll = "See All"
    
    // MARK: Navigation/View Titles
    
    static let addRecipe = "Add Recipe"
    static let yourRecipes = "Your Recipes"
    static let allRecipes = "All Recipes"
    
    // MARK: Onboarding
    
    static let onboardingItemOneTitle = "Search Recipe"
    static let onboardingItemOneDesc = "Search your desired recipe using the in-built browser or Safari."
    static let onboardingItemTwoTitle = "Save it!"
    static var onboardingItemTwoDesc: AttributedString {
        let displayName = Bundle.main.displayName ?? "app"
        var attrString = AttributedString("Using the browser's Share option, select the \(displayName) to save it.")
        
        if let range = attrString.range(of: displayName) {
            attrString[range].font = Font.system(size: 16, weight: .bold)
        }
        
        return attrString
    }
    
    // MARK: Descriptions
    
    static var noRecipesDescription: AttributedString {
        let actionString = "Add Recipe"
        var attrString = AttributedString(
            "You haven't saved any recipes yet. Start by pressing the \(actionString) button."
        )
        
        if let range = attrString.range(of: actionString) {
            attrString[range].foregroundColor = Color.accentColor
        }
        
        return attrString
    }
    
    // MARK: Constants
    
    static let extensionGroup = "group.JJC.RecipeParser"
    static let ingredients = "Ingredients"
    static let instructions = "Instructions"
    static let prepTime = "Prep. Time:"
    static let cookTime = "Cook Time:"
    static let noRecipes = "No Recipes"
    static let noFavourites = "No Favourites"
    static let searchRecipe = "Search \"Hamburger\" or \"Mexican\""
    static let sortBy = "Sort By:"
}

// MARK: Functions

extension String {
    /// Generates a placeholder text. Typically used for skeleton views.
    /// - Parameter length: The length of the string.
    /// - Returns: `String` containing `length` number of characters.
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
