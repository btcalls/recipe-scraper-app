//
//  Utils.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/5/2025.
//

import Foundation
import SwiftUI

// MARK: Observables

@Observable
final class AppSettings {
    enum RootView {
        case onboarding
        case home
    }
    
    var rootView: RootView = .onboarding
}

@Observable
final class ViewState {
    var isProcessing = false
    var toast: ToastView.State?
}

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
