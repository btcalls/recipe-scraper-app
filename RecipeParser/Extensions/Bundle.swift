//
//  Bundle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 7/5/2025.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
