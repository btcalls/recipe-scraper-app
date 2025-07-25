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

enum AspectRatio: CGFloat {
    case square = 1
    case threeToFour = 0.75
    case fourToThree = 1.75
}

enum CornerRadius: CGFloat {
    case sm = 8
    case regular = 16
    case lg = 24
}

enum Spacing: CGFloat {
    case xs = 5
    case sm = 8
    case regular = 10
    case lg = 20
}

enum EmptyViewType {
    case generic
    case search(String?)
}

enum FocusedField {
    case search
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
    case xmarkCircle = "xmark.circle.fill"
    case plus
    case bullet = "circle.fill"
    case link
    case arrowUp = "arrowtriangle.up"
    case arrowDown = "arrowtriangle.down"
    case arrowLeft = "arrowtriangle.left"
    case arrowRight = "arrowtriangle.right"
    case chevronRightCircle = "chevron.right.circle.fill"
    case search = "magnifyingglass"
    case sort = "arrow.up.arrow.down"
    case checkmark
    case checkmarkCircle = "checkmark.circle"
    case bookmark
    case bookmarkFill = "bookmark.fill"
    case list = "checklist"
    case save = "square.and.arrow.down"
}
