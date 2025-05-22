//
//  HomeEndpoints.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import Foundation

enum HomeEndpoints: APIEndpoint {
    case getRecipes
    case addRecipe(Recipe)
    case updateRecipe(Recipe)
    case parseRecipe(URL)
}

extension HomeEndpoints {
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
    var parameters: [URLQueryItem]? {
        return nil
    }
    var body: Data? {
        switch self {
        case .addRecipe(let value), .updateRecipe(let value):
            return try? value.encoded()
        
        case .parseRecipe(let url):
            return try? JSONSerialization.data(withJSONObject: ["url": url.absoluteString],
                                               options: [])
        
        default:
            return nil
        }
    }
}
