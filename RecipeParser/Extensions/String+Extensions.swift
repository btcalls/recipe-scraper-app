//
//  String.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import Foundation
import SwiftUI

extension String {
    func highlight(_ words: [String],
                   font: Font = .default.bold(),
                   color: Color = Color.appForeground) -> AttributedString {
        var attrString = AttributedString(self)
        
        for word in words {
            if let range = attrString.range(of: word) {
                attrString[range].inlinePresentationIntent = .stronglyEmphasized
                attrString[range].foregroundColor = color
            }
        }
        
        return attrString
    }
    
    func highlight(_ word: String,
                   font: Font = .default.bold(),
                   color: Color = Color.appForeground) -> AttributedString {
        return highlight([word], font: font, color: color)
    }
}

extension String {
    // MARK: Buttons
    
    static let cancel = "Cancel"
    static let saveRecipe = "Save Recipe"
    static let getStarted = "Get Started"
    static let processing = "Processing..."
    static let parsingRecipe = "Parsing Recipe..."
    static let seeAll = "See All"
    static let markComplete = "Mark as Complete"
    
    // MARK: Navigation/View Titles
    
    static let addRecipe = "Add Recipe"
    static let yourRecipes = "Your Recipes"
    static let allRecipes = "All Recipes"
    static let success = "Hooray!"
    
    // MARK: Onboarding
    
    static let onboardingItemOneTitle = "Search"
    static var onboardingItemOneDesc: AttributedString {
        let browser = "Safari"
        let string = "From within the app or the \(browser) browser, search for your favourite recipes."
        
        return string.highlight(browser)
    }
    static let onboardingItemTwoTitle = "View"
    static var onboardingItemTwoDesc: AttributedString {
        let displayName = Bundle.main.displayName ?? "Recipe App"
        let action = "Share"
        let string = "Using the browser's \(action) option, select \(displayName) to view its details and save it."
        
        return string.highlight([displayName, action])
        
    }
    static let onboardingItemThreeTitle = "Save"
    static var onboardingItemThreeDesc: AttributedString {
        let hookStatement = "ads and clutter not included"
        let string = "By selecting \(String.saveRecipe), you now have offline access to any recipes you want—\(hookStatement)."
        
        return string.highlight([.saveRecipe, hookStatement])
    }
    
    // MARK: Descriptions
    
    static let cookCompleteConfirmation = "Would you like to mark this recipe and your cooking session as completed?"
    
    static var noRecipesDescription: AttributedString {
        let action = "Add Recipe"
        let string = "Save your first recipe by pressing the \(action) button."
        
        return string.highlight(action, color: .accent)
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
