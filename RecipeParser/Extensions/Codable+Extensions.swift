//
//  Codable.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

extension JSONEncoder {
    static var standard: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        
        return encoder
    }
}

extension JSONDecoder {
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
}

extension Decodable {
    /// Decodes an instance of type `T` from a JSON file.
    /// - Parameter filename: The filename of the JSON file.
    /// - Returns: Optional. Decoded instance `T`.
    static func fromJSONFile<T: Decodable>(_ filename: String) throws -> T? {
        let path = Bundle.main.path(forResource: filename, ofType: "json")
        
        guard let path, let data = try? Data(
            contentsOf: URL(filePath: path),
            options: .mappedIfSafe
        ) else {
            return nil
        }
        
        return try? data.decoded()
    }
}

extension Encodable {
    /// Converts a `Encodable` instance to a JSON object to be used for form submission.
    /// - Returns: Encoded `Data` instance.
    func encoded() throws -> Data {
        return try JSONEncoder.standard.encode(self)
    }
}
