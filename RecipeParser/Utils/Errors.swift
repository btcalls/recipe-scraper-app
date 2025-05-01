//
//  CustomError.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

enum NetworkResponse: String {
    case authError = "Request needs to be authenticated."
    case badRequest = "Bad request."
    case failed = "Network request failed."
    case offline = "Network is offline."
    case noData = "Response returned with no data to decode."
    case decodeError = "Could not decode response."
}

enum AppResponse: String {
    case URLOpenError = "App cannot open specified URL."
}

enum CustomError: LocalizedError {
    case network(NetworkResponse)
    case app(AppResponse)
    case error(Error)
    case custom(String)
}
