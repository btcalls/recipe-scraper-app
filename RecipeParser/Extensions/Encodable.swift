//
//  Encodable.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

extension Encodable {
    /// Converts a `Encodable` instance to a JSON object to be used for form submission.
    /// - Parameter key: Encoding strategy to be used.
    /// - Returns: Optional. `Data` instance.
    func toJSONData(
        key: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    ) throws -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = key
        
        return try encoder.encode(self)
    }
}
