//
//  Endpoint.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation

extension APIEndpoint {
    var path: String {
        return ""
    }
    var method: HTTPMethod {
        return .GET
    }
    var parameters: [URLQueryItem]? {
        return nil
    }
    var body: Data? {
        return nil
    }
}
