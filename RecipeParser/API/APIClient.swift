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
        guard let _ = AppValues.shared.accessToken else {
            return false
        }
        
        return true
    }
    
    func send<D: AppModel>(_ endpoint: APIEndpoint) async throws -> D {
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
    
    func send<T: AppModel>(_ endpoint: APIEndpoint,
                           storeTo context: ModelContext? = nil) async throws -> Model<T> {
        let obj: T = try await send(endpoint)
        
        do {
            if let context {
                context.insert(obj)
                try context.save()
            }
            
            return .init(obj)
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
        request.httpBody = endpoint.body
        
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
