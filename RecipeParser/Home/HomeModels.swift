//
//  HomeModels.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation

// MARK: Models

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

// MARK: Network

struct PostEndpoint: Endpoint {
    var path: String = "/posts"
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]?
    var isAuthenticated: Bool = false
    
    // Endpoints for /posts path
    static var getPosts: PostEndpoint {
        return .init()
    }
}

struct PostRequest: APIRequest {
    typealias Response = [Post]
    typealias RequestEndpoint = PostEndpoint
    
    var endpoint: PostEndpoint
}

