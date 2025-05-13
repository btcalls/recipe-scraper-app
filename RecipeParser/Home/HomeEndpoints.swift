//
//  HomeEndpoints.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import Foundation

enum HomeEndpoints: APIEndpoint {
    case getPosts
    case addRecipe(Recipe)
    case updateRecipe(Recipe)
}

extension HomeEndpoints {
    var path: String {
        switch self {
        default:
            return "/posts"
        }
    }
    var body: Data? {
        switch self {
        case .addRecipe(let value), .updateRecipe(let value):
            return try? value.toJSONData()
        default:
            return nil
        }
    }
}
