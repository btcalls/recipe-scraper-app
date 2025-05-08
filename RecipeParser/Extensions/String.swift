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
    static let parseRecipe = "Parse Recipe"
    
    // MARK: Navigation/View Titles
    static let addNewRecipe = "Add New Recipe"
    static let parseViaURL = "Parse Recipe via URL"
    
    // MARK: Titles and Captions
    static let pasteURL = "Paste URL"
    static let pasteURLPlaceholder = "https://www.recipe.com/burger"
    static let pasteURLDescription = "Select a recipe websites's URL and paste it here."
    static let openBrowser = "Open Browser"
    
    static var openBrowserDescription: AttributedString {
        let displayName = Bundle.main.displayName ?? "app"
        var attrString = AttributedString("Search your desired recipe from the in-built browser. Share the URL and select the \(displayName) option to parse it.")
        
        if let range = attrString.range(of: displayName) {
            attrString[range].font = Font.system(size: 16, weight: .bold)
        }
        
        return attrString
    }
    
    // MARK: Constants
    static let googleURL = "https://www.google.com"
    
    // MARK: Functions
    
    /// Generates a placeholder text. Typically used for skeleton views.
    /// - Parameter length: The length of the string.
    /// - Returns: `String` containing `length` number of characters.
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
