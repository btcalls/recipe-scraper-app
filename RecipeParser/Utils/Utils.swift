//
//  Utils.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/5/2025.
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

final class ViewState: ObservableObject {
    @Published var isProcessing = false
    @Published var toast: ToastView.State?
}
