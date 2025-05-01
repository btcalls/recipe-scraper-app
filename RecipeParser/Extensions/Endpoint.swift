//
//  Endpoint.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation

extension Endpoint {
    var url: URL {
        // TODO: Base URL from Bundle
        var url = URL(string: "https://jsonplaceholder.typicode.com")!
        url = url.appendingPathComponent(path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    var headers: [String: Any] {
        let values: [String: String] = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        // TODO: Access token or auth handling
//        if isAuthenticated, let token: String = UserDefaults.standard.get(.accessToken) {
//            values["Authorization"] = "Bearer \(token)"
//        }
        
        return values
    }
}
