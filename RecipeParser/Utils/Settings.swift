//
//  Utils.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/5/2025.
//

// MARK: Settings

final class AppValues {
    /// Global instances of `AppValues`.
    static var shared = AppValues()
    
    /// Optional. Access token used for endpoint authentication.
    @UserDefaultsWrapper(
        key: "accessToken",
    )
    var accessToken: String? = nil
    
    /// Flag whether user has completed the onboarding process.
    @UserDefaultsWrapper(
        key: "isOnboardingComplete",
        storage: .init(suiteName: .extensionGroup) ?? .standard
    )
    var isOnboardingComplete: Bool = false
}
