//
//  APIClient.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import Combine

enum HTTPMethod {
    case get
    case post(Encodable?)
    
    var value: String {
        switch self {
        case .get:
            return "GET"
            
        case .post(_):
            return "POST"
        }
    }
}

final class APIClient: NSObject {
    static let shared: APIClient = APIClient()
    
    var isAuthenticated: Bool {
        return false
        // TODO: Handle authentication
//        guard let _: String = UserDefaults.standard.get(.accessToken) else {
//            return false
//        }
//        
//        return true
    }
    
    func send<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, Error> {
        let urlRequest = getURLRequest(for: request)
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession(configuration: config).dataTaskPublisher(for: urlRequest)
            .mapError { CustomError.error($0) }
            .tryMap { [weak self] data, response -> Data in
                if let error = self?.getHttpError(response) {
                    throw error
                }
                
                if let json = try? data.toJSON() {
                    Debugger.print(json)
                }
                
                return data
            }
            .decode(type: T.Response.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    private func getHttpError(_ response: URLResponse?) -> CustomError? {
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
    
    private func getURLRequest<T: APIRequest>(for request: T) -> URLRequest {
        let endpoint = request.endpoint
        var urlRequest = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.httpMethod = endpoint.method.value
        
        Debugger.print(endpoint.url.absoluteString)
        
        // Configure body per request method
        switch endpoint.method {
        case .post(let encodable):
            if let httpBody = try? encodable?.toJSONData() {
                if let json = try? httpBody.toJSON() {
                    Debugger.print("Params: \(json)")
                }
                
                urlRequest.httpBody = httpBody
            }
            
        default:
            break
        }
        
        // Add Headers
        endpoint.headers.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
}
