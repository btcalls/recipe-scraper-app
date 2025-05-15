//
//  Data.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

extension Data {
    /// Converts a `Data` instance to a JSON object for easier debugging or for form submissions.
    /// - Returns: Optional. `[String: Any]` JSON instance.
    func toJSON() throws -> [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) {
            return json as? [String: Any]
        }
        
        return nil
    }
}
