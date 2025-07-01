//
//  RecipeEndpoints.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/5/2025.
//

import Foundation

enum RecipeEndpoints: APIEndpoint {
    case parseRecipe(URL)
    case updateRecipe(Recipe)
}

extension RecipeEndpoints {
    var path: String {
        let basePath = "/recipe"
        
        switch self {
        case .parseRecipe(_:):
            return "\(basePath)/parse"
            
        default:
            return basePath
        }
    }
    var method: HTTPMethod {
        switch self {
        case .parseRecipe(_:):
            return .POST
            
        default:
            return .GET
        }
    }
    var body: Data? {
        switch self {
        case .updateRecipe(let value):
            return try? value.encoded()
            
        case .parseRecipe(let url):
            let dict = ["url": url.absoluteString]
            
            return try? JSONSerialization.data(withJSONObject: dict,
                                               options: [])
        }
    }
}
