//
//  Constants.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import Foundation
import UIKit
import SwiftUI
import SFSymbolsMacro

// MARK: Errors

enum NetworkResponse: String {
    case authError = "Request needs to be authenticated."
    case invalidPath = "Invalid URL provided."
    case badRequest = "Bad request."
    case failed = "Network request failed."
    case offline = "Network is offline."
    case noData = "Response returned with no data to decode."
    case decodeError = "Could not decode response."
}

enum AppResponse: String {
    case URLOpenError = "App cannot open specified URL."
    case persistentDataLookupError = "Failed saving recipe. Please try again later."
}

enum CustomError: LocalizedError, Equatable {
    case network(NetworkResponse)
    case app(AppResponse)
    case error(Error)
    case custom(String)
}

// MARK: Networking

enum HTTPMethod: String {
    case GET
    case POST
}

// MARK: UI

enum CornerRadius: CGFloat {
    case sm = 5
    case regular = 10
    case lg = 15
}

@SFSymbol
enum Symbol: String {
    case documentOnClipboard = "document.on.clipboard"
    case globe
    case forkKnife = "fork.knife"
    case x = "xmark"
    case info = "info.circle.fill"
    case warning = "exclamationmark.triangle.fill"
    case success = "checkmark.circle.fill"
    case error = "xmark.circle.fill"
}
