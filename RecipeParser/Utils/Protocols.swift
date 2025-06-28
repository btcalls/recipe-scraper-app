//
//  Protocols.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: Networking

/// Protocol for configuring an API request by the endpoint path.
protocol APIEndpoint {
    /// The path the corresponding instance points to. Defaults to base URL.
    var path: String { get }
    /// The HTTP method of the corresponding endpoint.
    var method: HTTPMethod { get }
    /// Query parameters configured for API endpoints.
    var parameters: [URLQueryItem]? { get }
    /// Optional. Instance to be encoded as HTTP body and  added to a URL request.
    var body: Data? { get }
}

extension APIEndpoint {
    var path: String {
        return ""
    }
    var method: HTTPMethod {
        return .GET
    }
    var parameters: [URLQueryItem]? {
        return nil
    }
    var body: Data? {
        return nil
    }
}

// MARK: ViewModels

/// Protocol for implementing a base view model where business logic and processes are performed.
protocol ViewModel: ObservableObject {
    associatedtype Value
    
    /// Published property for data fetched by view model. Add @Published wrapper upon implementation.
    var data: Value { get set }
    /// Published property for errors catched by the view model. Add @Published wrapper upon implementation.
    var error: CustomError? { get set }
    
}

/// Protocol for implementing a view model with loading/processing functionalities in which result needs to be reflected in the view via toast or other means.
protocol LoadableViewModel: ViewModel {
    /// Published property for observing the view state in response to some action or process. This will include the type of toast to be presentend in response to a process completion. Add @Published wrapper upon implementation.
    var state: ViewState { get set }
}

/// Protocol for implementing a view model with fetching/reloading data capabilities used for populating a screen.
protocol FetchViewModel: LoadableViewModel {
    /// Function to initiate data fetching. Add @MainActor wrapper upon implementation.
    func fetchData() async throws
    /// Function to initiate data reloading. Add @MainActor wrapper upon implementation.
    func reloadData() async throws
}

///  Protocol for implementing a view model with processing capabilities (e.g. submission to a web service).
protocol ProcessViewModel: LoadableViewModel {
    associatedtype Body
    
    /// Process provided instance based on corresponding view model's business logic (e.g. API call, save to local storage, etc.)
    ///
    /// Add @MainActor wrapper upon implementation.
    /// - Parameter body: The instance to process.
    func process(_ body: Body) async
}

// MARK: UI

/// Protocol for implementing a custom button with option to specify type of display (e.g. icon-only, label).
protocol AppButton: View {
    associatedtype Display
    associatedtype ButtonKind
    
    var display: Display { get }
    var kind: ButtonKind { get }
    var tint: Color? { get }
    var action: @MainActor () -> Void { get }
}

// MARK: Models

protocol SortableModel {
    /// List of items to be used as selection for types of sorting.
    static var sortItems: [SortItem<Self>: [SortOrderItem]] { get }
    
    /// Retrieves the sort descriptor corresponding to the provided key path.
    /// - Parameters:
    ///   - keyPath: The key path corresponding to the conforming instance.
    ///   - order: The sort order.
    /// - Returns: `SortDescriptor` instance configured with given parameters.
    static func getSortDescriptor(for keyPath: PartialKeyPath<Self>,
                                  order: SortOrder) -> SortDescriptor<Self>
}
