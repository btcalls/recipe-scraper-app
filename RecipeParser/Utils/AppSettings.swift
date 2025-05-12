//
//  AppSettings.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 9/5/2025.
//

import Foundation

final class AppSettings {
    static let shared = AppSettings()
    
    @UserDefaultsWrapper(
        key: "isOnboardingComplete",
        storage: .init(suiteName: .extensionGroup) ?? .standard
    )
    var isOnboardingComplete: Bool = false
}
