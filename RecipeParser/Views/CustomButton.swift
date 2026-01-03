//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

private struct ImageAndLabelView: View {
    var display: CustomButton.Display
    var kind: CustomButton.Kind
    
    @ScaledMetric private var spacing = Layout.Spacing.small
    
    var body: some View {
        switch kind {
        case .regular, .wide:
            if let sfSymbol = display.icon {
                Label(display.title, sfSymbol: sfSymbol)
                    .labelIconToTitleSpacing(spacing)
            } else {
                Text(display.title)
            }
            
        case .loading(let title):
            HStack(alignment: .center, spacing: spacing) {
                ProgressView()
                
                Text(title)
            }
        }
    }
}

struct CustomButton: AppButton {
    typealias Display = (title: String, icon: Symbol?)
    typealias ButtonKind = Kind
    
    var display: (title: String, icon: Symbol?)
    var kind: Kind
    var role: ButtonRole? = .none
    var action: @MainActor () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    @ScaledMetric private var spacing = Layout.Spacing.small
    
    private var isDisabled: Bool {
        switch kind {
        case .loading(_:):
            return true
            
        default:
            return !isEnabled
        }
    }
    private var color: (bg: Color?, tint: Color?) {
        if case .loading(_:) = kind {
            return (nil, nil)
        }
        
        guard let role else {
            return (nil, .appForeground)
        }
        
        switch role {
        case .destructive:
            return (nil, nil)
        
        case .confirm:
            return (.accentColor, .appBackground)
            
        default:
            return (nil, .appForeground)
        }
    }
    
    @ViewBuilder private var label: some View {
        switch kind {
        case .wide:
            ImageAndLabelView(display: display, kind: kind)
                .frame(maxWidth: .infinity)
                
        default:
            ImageAndLabelView(display: display, kind: kind)
        }
    }
    
    var body: some View {
        Button(role: role, action: action) {
            label
                .font(.headline)
                .fontWeight(.medium)
                .padding()
        }
        .disabled(isDisabled)
        .glassEffect(.regular.interactive(!isDisabled).tint(color.bg))
        .tint(color.tint)
    }
}

extension CustomButton {
    enum Kind {
        case regular
        case wide
        case loading(String = .processing)
    }
    
    internal init(
        _ title: String,
        icon: Symbol? = nil,
        kind: Kind = .regular,
        role: ButtonRole? = .none,
        action: @escaping @MainActor () -> Void
    ) {
        self.display = (title, icon)
        self.kind = kind
        self.role = role
        self.action = action
    }
    
    internal init(
        _ title: String,
        role: ButtonRole? = .none,
        action: @escaping @MainActor () -> Void
    ) {
        self.display = (title, .none)
        self.kind = .regular
        self.role = role
        self.action = action
    }
}

extension CustomButton {
    static func loading(
        _ title: String = .processing,
        action: @escaping @MainActor () -> Void
    ) -> Self {
        return Self.init("",
                         kind: .loading(title),
                         action: action)
    }
}

#Preview {
    CustomButton("Sample") {}
    CustomButton("Save", kind: .wide, role: .confirm) {}
    CustomButton("Delete", icon: .x, kind: .regular, role: .destructive) {}
    CustomButton("Cancel", role: .cancel) {}
    CustomButton.loading("Testing Button") {}
}
