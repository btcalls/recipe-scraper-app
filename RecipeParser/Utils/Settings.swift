//
//  Utils.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/5/2025.
//

// MARK: Settings

final class AppValues {
    static var shared = AppValues()
    
    @UserDefaultsWrapper(
        key: "accessToken",
    )
    var accessToken: String? = nil
    
    @UserDefaultsWrapper(
        key: "isOnboardingComplete",
        storage: .init(suiteName: .extensionGroup) ?? .standard
    )
    var isOnboardingComplete: Bool = false
}
