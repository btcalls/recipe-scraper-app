//
//  Models.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import UIKit

struct RecipeMetadata {
    var title: String
    var description: String
    var hostName: String
    var image: UIImage? = nil
    var icon: UIImage? = nil
}

struct Recipe: Codable {
    var id: String
    var name: String
    var imageUrl: String
    var category: String
    var cuisine: String
    var description: String
    var prepTime: Double
    var totalTime: Double
    var instructions: [String]
    var ingredients: [Ingredient]
    var _description: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, imageUrl, category, cuisine, description, prepTime, totalTime, instructions, ingredients
        case _description = "instanceDescription"
    }
}

extension Recipe {
    static var sample: Self {
        return .init(
            id: "1zefe3",
            name: "Cheeseburger",
            imageUrl: "",
            category: "Main",
            cuisine: "American",
            description: "Tasty cheeseburger",
            prepTime: 20,
            totalTime: 40,
            instructions: [],
            ingredients: [],
            _description: ""
        )
    }
}

struct Ingredient: Codable {
    var name: String
    var amount: String?
    var method: String?
    var _description: String
    
    private enum CodingKeys: String, CodingKey {
        case name, amount, method
        case _description = "instanceDescription"
    }
}
