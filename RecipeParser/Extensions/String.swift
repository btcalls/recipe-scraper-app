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
    
    // MARK: Navigation/View Titles
    static let addNewRecipe = "Add New Recipe"
    static let yourRecipes = "Your Recipes"
    static let noRecipes = "No Recipes"
    static let noRecipesDescription = "You haven't saved any recipes yet."
    
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
    
    // MARK: Constants
    static let googleURL = "https://www.google.com"
    static let extensionGroup = "group.JJC.RecipeParser"
    
    // MARK: Functions
    
    /// Generates a placeholder text. Typically used for skeleton views.
    /// - Parameter length: The length of the string.
    /// - Returns: `String` containing `length` number of characters.
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
