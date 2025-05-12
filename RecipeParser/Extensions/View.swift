//
//  View.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

extension View {
    /// ViewBuilder for conditional application of `.redacted()` modifier based on `condition`.
    /// - Parameter condition: Condition in which if true, will apply a `.placeholder` reason.
    /// - Returns: Modified view.
    @ViewBuilder
    func redacted(as reason: RedactionReasons, if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? reason : [])
    }
    
    /// Modifier to add rounded borders to a View.
    /// - Parameters:
    ///   - cornerRadius: Value corner radius to be applied.
    ///   - lineWidth: Thickness of the border width.
    ///   - color: Color of the border.
    /// - Returns: Modified view with rounded borders.
    func rounded(cornerRadius: CGFloat,
                 lineWidth: CGFloat = 0,
                 color: Color = .clear) -> some View {
        modifier(RoundedView(cornerRadius: cornerRadius,
                             lineWidth: lineWidth,
                             color: color))
    }
    
    /// Modifier to implement default `shadow()` across views.
    /// - Returns: Modified view with shadow.
    func shadow() -> some View {
        shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15),
               radius: 8,
               x: 6,
               y: 8)
    }
}
