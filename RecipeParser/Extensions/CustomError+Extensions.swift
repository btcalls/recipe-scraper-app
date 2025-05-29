//
//  CustomError.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation

extension CustomError {
    /// Detailed description for the custom error instance.
    var description: String {
        switch self {
        case .network(let message):
            return NSLocalizedString(message.rawValue, comment: "Network Error")
            
        case .app(let message):
            return NSLocalizedString(message.rawValue, comment: "App Error")
            
        case .error(let error):
            return NSLocalizedString(error.localizedDescription, comment: "Error")
            
        case .custom(let message):
            return NSLocalizedString(message, comment: "Error")
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.network(let val1), .network(let val2)):
            return val1 == val2
            
        case (.app(let val1), .app(let val2)):
            return val1 == val2
            
        case (.error(let val1), .error(let val2)):
            return val1.localizedDescription == val2.localizedDescription
            
        case (.custom(let val1), .custom(let val2)):
            return val1 == val2
            
        default:
            return false
        }
    }
}
