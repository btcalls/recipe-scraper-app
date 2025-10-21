//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

private struct ImageAndLabelView: View {
    var display: WideButton.Display
    var kind: WideButton.Kind
    
    @ScaledMetric private var spacing: CGFloat = 10
    
    var body: some View {
        switch kind {
        case .regular:
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

struct WideButton: AppButton {
    typealias Display = (title: String, icon: Symbol?)
    typealias ButtonKind = Kind
    
    var display: (title: String, icon: Symbol?)
    var kind: Kind
    var role: ButtonRole? = .none
    var action: @MainActor () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    @ScaledMetric private var spacing: CGFloat = 8
    
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
            return (.accentColor, .white)
        }
        
        switch role {
        case .destructive:
            return (nil, nil)
            
        case .cancel:
            return (nil, .appForeground)
        
        default:
            return (.accentColor, .white)
        }
    }
    
    var body: some View {
        Button(role: role, action: action) {
            ImageAndLabelView(display: display, kind: kind)
                .bold()
                .padding()
        }
        .disabled(isDisabled)
        .glassEffect(.regular.interactive(!isDisabled).tint(color.bg))
        .tint(color.tint)
    }
}

extension WideButton {
    enum Kind {
        case regular
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

extension WideButton {
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
    WideButton("Sample") {}
    WideButton("Delete", icon: .x, kind: .regular, role: .destructive) {}
    WideButton("Cancel", role: .cancel) {}
    WideButton.loading("Testing Button") {}
}
