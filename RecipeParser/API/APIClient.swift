//
//  APIClient.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

final class APIClient: NSObject {
    static let shared = APIClient()
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    var isAuthenticated: Bool {
        return false
        // TODO: Handle authentication
//        guard let _: String = UserDefaults.standard.get(.accessToken) else {
//            return false
//        }
//        
//        return true
    }
    
    func send<D: Decodable>(_ endpoint: APIEndpoint) async throws -> D {
        let urlRequest = try getURLRequest(from: endpoint)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        if let error = getHttpError(urlResponse) {
            throw error
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(D.self, from: data)
        } catch {
            Debugger.print(error)
            throw CustomError.network(.decodeError)
        }
    }
}

private extension APIClient {
    func getHttpError(_ response: URLResponse?) -> CustomError? {
        guard let response = response as? HTTPURLResponse else {
            return .network(.failed)
        }
        
        switch response.statusCode {
        case 200...299:
            return nil
            
        case 401...500:
            return .network(.authError)
            
        case 501...599:
            return .network(.badRequest)
            
        default:
            return .network(.failed)
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
        
        // Configure body per request method
        if let httpBody = try? endpoint.body?.toJSONData() {
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
