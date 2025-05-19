//
//  View.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

// MARK: Modifiers

extension View {
    /// Modifier to present a `ToastView` to this view.
    /// - Parameters:
    ///   - state: Optional. Binding state in which the toast will be based upon.
    ///   - duration: The duration in which the toast may be dismissed after certain interval, or persisted indefinitely.
    ///   - onDismiss: Action to take upon explicitly closing the toast.
    /// - Returns: Modified view with toast presented.
    func presentToast(as state: Binding<ToastView.State?>,
                      duration: ToastView.Duration = .timed(4),
                      onDismiss: @escaping @MainActor () -> Void) -> some View {
        modifier(ToastModifier(state: state,
                               duration: duration,
                               onDismiss: onDismiss))
    }
    
    /// Modifier for conditional application of `.redacted()` modifier based on `condition`.
    /// - Parameter condition: Condition in which if true, will apply a `.placeholder` reason.
    /// - Returns: Modified view with redacted application.
    func redacted(as reason: RedactionReasons,
                  if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? reason : [])
    }
    
    /// Modifier to add rounded borders to a View.
    /// - Parameters:
    ///   - cornerRadius: Value corner radius to be applied.
    ///   - lineWidth: Thickness of the border width.
    ///   - color: Color of the border.
    /// - Returns: Modified view with rounded borders.
    func rounded(cornerRadius: CornerRadius = .sm,
                 lineWidth: CGFloat = 0,
                 color: Color = .clear) -> some View {
        modifier(RoundedViewModifier(cornerRadius: cornerRadius,
                                     lineWidth: lineWidth,
                                     color: color))
    }
    
    /// Modifier to implement default `shadow()` across views.
    /// - Returns: Modified view with shadow.
    /// - Parameter colorScheme: Optional. The app's current color scheme.
    func shadow(basedOn colorScheme: ColorScheme? = nil) -> some View {
        var color = Color.darkShadowColor
        
        if let colorScheme, colorScheme == .dark {
            color = .lightShadowColor
        }
        
        return shadow(color: color, radius: 10, x: 2, y: 10)
    }
}
