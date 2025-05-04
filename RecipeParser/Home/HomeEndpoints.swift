//
//  HomeEndpoints.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import Foundation

enum HomeEndpoints: APIEndpoint {
    case getPosts
    case addPost(Test)
    case updatePost(Test)
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
        case .addPost(let value), .updatePost(let value):
            return try? value.toJSONData()
        default:
            return nil
        }
    }
}
