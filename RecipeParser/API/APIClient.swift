//
//  APIClient.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import SwiftData

final class APIClient<E: APIEndpoint>: Sendable {
    /// Configures and sends a URL request based on provided endpoint.
    /// - Parameter endpoint: The endpoint details in which to base the request.
    /// - Returns: The decoded response from the API endpoint.
    func request<T: AppModel>(_ endpoint: E) async throws -> T {
        do {
            let urlRequest = try getURLRequest(from: endpoint)
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            try getHttpError(urlResponse)
            
            return try data.decoded()
        } catch let e as CustomError {
            Debugger.critical(e)
            throw e
        } catch let e {
            Debugger.critical(e)
            throw CustomError.error(e)
        }
    }
    
    /// Configures and sends a URL request based on provided endpoint. Saves decoded response to the model context provided.
    /// - Parameters:
    ///   - endpoint: The endpoint details in which to base the request.
    ///   - container: The model container in which the model database is generated.
    /// - Returns: The decoded response wrapped in `Model` instance.
    func request<T: AppModel>(_ endpoint: E,
                              storeTo container: ModelContainer) async throws -> ModelDTO<T> {
        let databaseActor = DatabaseActor(modelContainer: container)

        do {
            let urlRequest = try getURLRequest(from: endpoint)
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            try getHttpError(
                urlResponse,
                details: data.toJSON()?["detail"] as? String
            )
            try await databaseActor.save(data: data, as: T.self)
            
            return try .init(data.decoded())
        } catch let e as CustomError {
            Debugger.critical(e)
            throw e
        } catch let e {
            Debugger.critical(e)
            throw CustomError.error(e)
        }
    }
}

private extension APIClient {
    /// Checks network response for authentication, server, or other related errors.
    /// - Parameters:
    ///   - response: The `URLResponse` executed.
    ///   - details: Optional. Descriptive error message from server.
    func getHttpError(_ response: URLResponse?, details: String? = nil) throws {
        let response = try (response as? HTTPURLResponse).orThrow(
            CustomError.network(.failed)
        )
        
        switch response.statusCode {
        case 200...299:
            return
            
        case 401...500:
            if let details {
                throw CustomError.custom(details)
            } else {
                throw CustomError.network(.authError)
            }
            
        case 501...599:
            if let details {
                throw CustomError.custom(details)
            } else {
                throw CustomError.network(.badRequest)
            }
            
        default:
            throw CustomError.network(.failed)
        }
    }
    
    /// Retrieves the corresponding `URLRequest` instance for a given endpoint.
    /// - Parameter endpoint: The endpoint to configure request from.
    /// - Returns: The configured `URLRequest` instance.
    func getURLRequest(from endpoint: E) throws -> URLRequest {
        guard
            let apiURL = Bundle.main.apiURL,
            let urlPath = URL(string: apiURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path())
        else {
            throw CustomError.network(.invalidPath)
        }
        
        // Setup query parameters
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        // Setup request body
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        // Setup header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // TODO: Add auth headers
        if let accessToken = AppValues.shared.accessToken {
            request
                .setValue(
                    "Basic \(accessToken)",
                    forHTTPHeaderField: "Authorization"
                )
        }
        
        return request
    }
}
