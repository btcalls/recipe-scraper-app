//
//  Bundle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 7/5/2025.
//

import Foundation

extension Bundle {
    /// Retrieves URL for base API service used.
    var apiURL: String? {
        let key = "CONFIG_API_URL"
        
        guard let url = fetch("CONFIG_API_URL") as String? else {
            fatalError("Could not fetch value for \(key)")
        }
        
        return "https://\(url)"
    }
    /// Retrieves app's display name.
    var displayName: String? {
        return fetch("CFBundleDisplayName") as String?
    }
    
    /// Retrieves value from Bundle instance for given key.
    /// - Parameter key: The key to lookup value for.
    /// - Returns: Optional. Value of type `T`.
    private func fetch<T>(_ key: String) -> T? {
        return object(forInfoDictionaryKey: key) as? T
    }
}
