//
//  String.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

extension String {
    // MARK: Buttons
    static let cancel = "Cancel"
    static let parseRecipe = "Parse Recipe"
    
    // MARK: Navigation/View Titles
    static let addNewRecipe = "Add New Recipe"
    
    // MARK: Titles and Captions
    static let pasteURL = "Paste URL"
    static let pasteURLDescription = "Select a Recipe Website's URL and paste it here."
    static let openBrowser = "Open Browser"
    static let openBrowserDescription = "Search the recipe from the in-built browser. Click on the \"Save\" button to start parsing."
    
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
