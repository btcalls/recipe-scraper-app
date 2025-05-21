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
            Debugger.print(error)
            throw CustomError.custom(error.localizedDescription)
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
        
        switch response.statusCode {
        case 200...299:
            return
            
        case 401...500:
            throw CustomError.network(.authError)
            
        case 501...599:
            throw CustomError.network(.badRequest)
            
        default:
            throw CustomError.network(.failed)
        }
    }
    
    func getURLRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        guard
            let urlPath = URL(string: baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path())
        else {
            throw CustomError.network(.invalidPath)
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        
        if let httpBody = endpoint.body {
            // NOTE: For debugging purposes only
            if let json = try? httpBody.toJSON() {
                Debugger.print("Params: \(json)")
            }
            
            request.httpBody = httpBody
        }
        
        // TODO: Add auth headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
