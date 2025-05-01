//
//  Protocols.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

// MARK: Networking

/// Protocol for creating an API request instance consisting of its Endpoint, HTTP method, and type of Codable response.
protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype RequestEndpoint: Endpoint
    
    var endpoint: RequestEndpoint { get }
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get set }
    var isAuthenticated: Bool { get }
}

/// Protocol for implementing a view model with fetching/reloading data capabilities used for populating a screen.
protocol ViewModel {
    associatedtype Value
    
    /// Published property for data fetched by view model. Add @Published wrapper upon implementation.
    var data: Value { get set }
    /// Published property for error received by view model. Add @Published wrapper upon implementation.
    var error: CustomError? { get }
    /// Published property for fetching state managed by view model. Add @Published wrapper upon implementation.
    var isFetching: Bool { get set }
    
    func fetchData()
    func reloadData()
}
