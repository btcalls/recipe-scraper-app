//
//  APIClient.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import SwiftData

final class APIClient: NSObject {
    static let shared = APIClient()
    
    private let baseURL = "https://recipe-scraper-api-r1ui.onrender.com"
    
    var isAuthenticated: Bool {
        return false
        // TODO: Handle authentication
//        guard let _: String = UserDefaults.standard.get(.accessToken) else {
//            return false
//        }
//        
//        return true
    }
    
    func send<D: AppModel>(_ endpoint: APIEndpoint) async throws -> D {
        let urlRequest = try getURLRequest(from: endpoint)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        try getHttpError(urlResponse)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(D.self, from: data)
        } catch {
            Debugger.critical(error)
            throw CustomError.error(error)
        }
    }
    
    func send<T: AppModel>(_ endpoint: APIEndpoint,
                           storeTo context: ModelContext? = nil) async throws -> Model<T> {
        let obj: T = try await send(endpoint)
        
        if let context {
            context.insert(obj)
            try context.save()
        }
        
        return .init(obj)
    }
}

private extension APIClient {
    func getHttpError(_ response: URLResponse?) throws {
        let response = try (response as? HTTPURLResponse).orThrow(
            CustomError.network(.failed)
        )
        
        var error: CustomError? = nil
        
        switch response.statusCode {
        case 200...299:
            return
            
        case 401...500:
            error = CustomError.network(.authError)
            
        case 501...599:
            error = CustomError.network(.badRequest)
            
        default:
            error = CustomError.network(.failed)
        }
        
        guard let error else {
            return
        }
        
        Debugger.critical(error)
        throw error
    }
    
    func getURLRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        guard
            let urlPath = URL(string: baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path())
        else {
            let error = CustomError.network(.invalidPath)
            
            Debugger.critical(error)
            throw error
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        // TODO: Add auth headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
