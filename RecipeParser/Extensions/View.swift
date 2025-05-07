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
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
    
    /// Modifier to add rounded borders to a View.
    /// - Parameters:
    ///   - cornerRadius: Value corner radius to be applied.
    ///   - lineWidth: Thickness of the border width.
    ///   - color: Color of the border.
    /// - Returns: Modified view with rounded borders.
    func rounded(cornerRadius: CGFloat,
                 lineWidth: CGFloat,
                 color: Color) -> some View {
        modifier(RoundedView(cornerRadius: cornerRadius,
                             lineWidth: lineWidth,
                             color: color))
    }
}
