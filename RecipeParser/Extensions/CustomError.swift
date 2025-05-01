//
//  CustomError.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation

extension CustomError {
    
    var errorDescription: String? {
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
    
}
