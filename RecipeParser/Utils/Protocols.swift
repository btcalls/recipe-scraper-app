//
//  Protocols.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

// MARK: Networking

/// Protocol for configuring an API request by the endpoint path.
protocol APIEndpoint {
    /// The path the corresponding instance points to. Defaults to base URL.
    var path: String { get }
    /// The HTTP method of the corresponding endpoint.
    var method: HTTPMethod { get }
    /// Query parameters configured for API endpoints.
    var parameters: [URLQueryItem]? { get }
    /// Instance to be encoded as HTTP body and  added to a URL request.
    var body: Data? { get }
}

/// Protocol for implementing a base view model where business logic and processes are performed.
protocol ViewModel {
    associatedtype Value
    
    /// Published property for data fetched by view model. Add @Published wrapper upon implementation.
    var data: Value { get set }
    /// Published property for fetching state managed by view model. Add @Published wrapper upon implementation.
    var isFetching: Bool { get set }
    /// Published property for errors catched by the view model. Add @Published wrapper upon implementation.
    var error: CustomError? { get set }
}

/// Protocol for implementing a view model with fetching/reloading data capabilities used for populating a screen.
protocol FetchViewModel: ViewModel {
    /// Function to initiate data fetching. Add @MainActor wrapper upon implementation.
    func fetchData() async throws
    /// Function to initiate data reloading. Add @MainActor wrapper upon implementation.
    func reloadData() async throws
}

protocol ProcessViewModel: ViewModel {
    associatedtype Body
    
    /// Process provided instance based on corresponding view model's business logic (e.g. API call, save to local storage, etc.)
    ///
    /// Add @MainActor wrapper upon implementation.
    /// - Parameter body: The instance to process.
    func process(_ body: Body) async
}
