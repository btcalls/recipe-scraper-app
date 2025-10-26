//
//  View.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

// MARK: New Views

extension View {
    /// Modifier to display a `ContentUnavailableView` given the condition is fulfilled.
    /// - Parameters:
    ///   - label: `Label` that makes up the main title of the view.
    ///   - condition: The condition to display the view.
    ///   - type: The type of empty view to display.
    ///   - description: Optional. The details of the view.
    ///   - actions: Optional. Actions to display along the view.
    /// - Returns: Modified view with unavailable view option.
    func emptyView<Label, Actions>(
        _ label: Label,
        if condition: Bool,
        type: EmptyViewType = .generic,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) -> some View where Label : View, Actions : View  {
        return modifier(EmptyViewModifier(for: type,
                                          if: condition,
                                          label: label,
                                          description: description,
                                          actions: actions))
    }
    
    /// Modifier to display a `ContentUnavailableView` given the condition is fulfilled.
    /// - Parameters:
    ///   - type: The type of empty content view to display.
    ///   - condition: The condition to display the view.
    ///   - label: `Label` that makes up the main title of the view.
    ///   - description: Optional. The description displayed as a configured view.
    ///   - actions: Optional. Actions to display along the view.
    /// - Returns: Modified view with unavailable view option.
    func emptyView<Label, Description, Actions>(
        type: EmptyViewType = .generic,
        if condition: Bool,
        label: Label,
        @ViewBuilder description: () -> Description = EmptyView.init,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) -> some View where Label : View, Description: View, Actions : View  {
        return modifier(EmptyViewModifier(for: type,
                                          if: condition,
                                          label: label,
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
}

// MARK: View Modifiers

extension View {
    /// Removes animation for this `View`.
    /// - Returns: `View` with no animation attached.
    func disableAnimation() -> some View {
        return transaction { value in
            value.animation = nil
        }
    }
    
    /// Modifier to hide `View` given a condition.
    /// - Parameters:
    ///   - condition: The condition to hide the view.
    /// - Returns: Modified view.
    func hidden(if condition: Bool) -> some View {
        return modifier(HiddenViewModifier(condition: condition, remove: false))
    }
    
    /// Modifier to hide `View` given a condition and remove it from the current hierarchy.
    /// - Parameters:
    ///   - condition: The condition to hide and remove the view.
    /// - Returns: Modified view.
    func remove(if condition: Bool) -> some View {
        return modifier(HiddenViewModifier(condition: condition, remove: true))
    }
    
    /// Modifier for conditional application of `.redacted()` modifier based on `condition`.
    /// - Parameter condition: Condition in which if true, will apply a `.placeholder` reason.
    /// - Returns: Modified view with redacted application.
    func redacted(as reason: RedactionReasons,
                  if condition: Bool) -> some View {
        return redacted(reason: condition ? reason : [])
    }
    
    /// Modifier to implement default `shadow()` across views.
    /// - Returns: Modified view with shadow.
    func shadow(_ color: Color = .black) -> some View {
        return shadow(color: color.opacity(0.3), radius: 5, x: 2, y: 5)
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
    func clipTo<S: Shape>(_ shape: S,
                          lineWidth: CGFloat = 0,
                          color: Color = .clear) -> some View {
        return modifier(
            ShapeAndBorderModifier(
                shape: shape,
                color: color,
                lineWidth: lineWidth
            )
        )
    }
    
    /// Fits view to specified aspect ratio.
    /// - Parameter aspectRatio: The aspect ratio to set to the view.
    /// - Returns: Modified view fitted to desired aspect ratio.
    func fitToAspectRatio(_ aspectRatio: CGFloat) -> some View {
        return modifier(FitToAspectRatio(aspectRatio))
    }
    
    /// Fits view to specified aspect ratio.
    /// - Parameter aspectRatio: The aspect ratio to set to the view.
    /// - Returns: Modified view fitted to desired aspect ratio.
    func fitToAspectRatio(_ aspectRatio: AspectRatio) -> some View {
        return modifier(FitToAspectRatio(aspectRatio))
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
            RoundedRectangle(cornerRadius: cornerRadius),
            lineWidth: lineWidth,
            color: color
        )
    }
    
    /// Modifier to apply scaling to this view with given value.
    /// - Parameters:
    ///   - scaleType: The type in which the scaling is applied to.
    ///   - value: The value to be scaled.
    /// - Returns: Modified view with scaled value.
    func scale(_ scaleType: ScaledModifier.Kind, _ value: CGFloat) -> some View {
        return modifier(ScaledModifier(scaleType: scaleType, value: value))
    }
}

// MARK: Actions

extension View {
    /// Adds an action to perform when a notification from `NotificationCenter` is received.
    /// - Parameters:
    ///   - name: The notification received.
    ///   - center: The center to subscribe to.
    ///   - object: Optional. The object sent by the notification.
    ///   - action: The action to perform upon receiving the notification.
    /// - Returns: Modified view after receiving and processing the notification.
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}

// MARK: Navigation

extension View {
    /// Modifier to apply navigation capabilities to this view.
    /// - Parameter value: The value in which navigation will be based of.
    /// - Parameter shape: The shape to apply to both glass and view containers.
    /// - Returns: Modifed view with navigation in place.
    func asLink<Value, S: RoundedRectangularShape>(
        value: Value,
        shape: S = Capsule()
    ) -> some View where Value : Hashable {
        return modifier(NavigableViewModifier(value: value, shape: shape))
    }
}

// MARK: Views

extension Button where Label == Image {
    init(_ symbol: Symbol, role: ButtonRole? = .none, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action) {
            symbol.image
        }
    }
}

extension Divider {
    /// Apply app-standard modifiers to the `Divider`.
    /// - Returns: Modified divider.
    func asStandard() -> some View {
        return scale(.height(), 1)
            .background(.secondary.opacity(0.5))
    }
}

extension Edge.Corner.Style {
    static func concentric(minimum radius: CornerRadius) -> Edge.Corner.Style {
        return .concentric(minimum: .fixed(radius.rawValue))
    }
}

extension Label where Title == Text, Icon == Image  {
    init(_ title: String = "", sfSymbol: Symbol) {
        self.init(title, systemImage: sfSymbol.rawValue)
    }
    
    init(_ sfSymbol: Symbol, title: () -> Text) {
        self.init(title: title) {
            Icon(systemName: sfSymbol.rawValue)
        }
    }
}

extension Image {
    /// Fits view to specified aspect ratio.
    /// - Parameter aspectRatio: The aspect ratio to set to the view.
    /// - Returns: Modified view fitted to desired aspect ratio.
    func fitToAspectRatio(_ aspectRatio: CGFloat) -> some View {
        return resizable().modifier(FitToAspectRatio(aspectRatio))
    }
    
    /// Fits view to specified aspect ratio.
    /// - Parameter aspectRatio: The aspect ratio to set to the view.
    /// - Returns: Modified view fitted to desired aspect ratio.
    func fitToAspectRatio(_ aspectRatio: AspectRatio) -> some View {
        return resizable().modifier(FitToAspectRatio(aspectRatio))
    }
}

extension RoundedRectangle {
    init(
        cornerRadius value: CornerRadius,
        style: RoundedCornerStyle = .continuous
    ) {
        self.init(cornerRadius: value.rawValue, style: style)
    }
}

extension Toggle where Label == EmptyView {
    init(_ isOn: Binding<Bool>) {
        self.init(isOn: isOn) {
            EmptyView()
        }
    }
}
