//
//  Color+Extensions.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

extension Color {
    static let appBackground = Color("BackgroundColor")
    static let appForeground = Color("ForegroundColor")
}

extension LinearGradient {
    static let accent = Self(
        gradient: Gradient(
            colors: [Color.accent.opacity(0.75), Color.accent]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
}
