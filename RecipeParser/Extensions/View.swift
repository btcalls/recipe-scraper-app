//
//  View.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

// MARK: Modifiers

extension View {
    /// Modifier to display a `ContentUnavailableView` given the condition is fulfilled.
    /// - Parameters:
    ///   - condition: The condition to display the view.
    ///   - label: `Label` that makes up the main title of the view.
    ///   - description: Optional. The details of the view.
    ///   - actions: Optional. Actions to display along the view.
    /// - Returns: Modified view with unavailable view option.
    func emptyView<Label, Actions>(
        if condition: @autoclosure () -> Bool,
        label: Label,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) -> some View where Label : View, Actions : View  {
        return modifier(EmptyViewModifier(label,
                                          if: condition(),
                                          description: description,
                                          actions: actions))
    }
    
    /// Modifier to present a `ToastView` to this view.
    /// - Parameters:
    ///   - state: Optional. Binding state in which the toast will be based upon.
    ///   - duration: The duration in which the toast may be dismissed after certain interval, or persisted indefinitely.
    ///   - onDismiss: Action to take upon explicitly closing the toast.
    /// - Returns: Modified view with toast presented.
    func presentToast(as state: Binding<ToastView.State?>,
                      duration: ToastView.Duration = .timed(4),
                      onDismiss: @escaping @MainActor () -> Void) -> some View {
        return modifier(ToastModifier(state: state,
                                      duration: duration,
                                      onDismiss: onDismiss))
    }
    
    /// Modifier for conditional application of `.redacted()` modifier based on `condition`.
    /// - Parameter condition: Condition in which if true, will apply a `.placeholder` reason.
    /// - Returns: Modified view with redacted application.
    func redacted(as reason: RedactionReasons,
                  if condition: @autoclosure () -> Bool) -> some View {
        return redacted(reason: condition() ? reason : [])
    }
    
    /// Modifier to implement default `shadow()` across views.
    /// - Returns: Modified view with shadow.
    func shadow() -> some View {
        return shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 10)
    }
}

// MARK: Shape-related

extension View {
    /// Modifier to clip View to specified shape, and add border if applicable.
    /// - Parameters:
    ///   - shape: The `Shape` to apply.
    ///   - lineWidth: Thickness of the border width.
    ///   - color: Color of the border.
    /// - Returns: Modified view clipped to a circle shape, and drawn border, if applicable.
    func clipTo<S: Shape>(shape: S,
                          lineWidth: CGFloat = 0,
                          color: Color = .clear) -> some View {
        return modifier(
            ShapeAndBorderModifier(
                shape: shape,
                lineWidth: lineWidth,
                color: color
            )
        )
    }
    
    /// Modifier to clip View to a rounded rectangle.
    /// - Parameters:
    ///   - cornerRadius: Value corner radius to be applied.
    ///   - lineWidth: Thickness of the border width.
    ///   - color: Color of the border.
    /// - Returns: Modified view with rounded shape, and drawn border, if applicable.
    func rounded(cornerRadius: CornerRadius = .sm,
                 lineWidth: CGFloat = 0,
                 color: Color = .clear) -> some View {
        return clipTo(
            shape: RoundedRectangle(cornerRadius: cornerRadius),
            lineWidth: lineWidth,
            color: color
        )
    }
}

// MARK: Views

extension Label where Title == Text, Icon == Image  {
    init(_ title: String = "", symbol: Symbol) {
        self.init(title, systemImage: symbol.rawValue )
    }
}

extension RoundedRectangle {
    init(
        cornerRadius val: CornerRadius,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(cornerRadius: val.rawValue, style: style)
    }
}
