//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

struct WideButton: AppButton {
    typealias Display = (title: String, icon: Symbol?)
    typealias ButtonKind = Kind
    
    var display: (title: String, icon: Symbol?)
    var kind: Kind
    var tint: Color?
    var role: ButtonRole? = .none
    var action: @MainActor () -> Void
    
    @ScaledMetric private var spacing: CGFloat = 8
    
    private var isDisabled: Bool {
        switch kind {
        case .loading(_:):
            return true
            
        default:
            return false
        }
    }
    private var color: (bg: Color, tint: Color) {
        if case .loading(_:) = kind {
            return (Color(uiColor: .lightGray), .secondary)
        }
        
        guard let role else {
            return (.accentColor, .white)
        }
        
        switch role {
        case .destructive:
            return (.red, .white)
            
        case .cancel:
            return (.appBackground, .appForeground)
        
        default:
            return (.accentColor, .white)
        }
    }
    
    @ViewBuilder private func imageAndLabelView() -> some View {
        switch kind {
        case .regular(let styleKind), .wrapped(let styleKind):
            if let sfSymbol = display.icon, let styleKind {
                Label(display.title, sfSymbol: sfSymbol)
                    .labelStyle(CustomLabelStyle(styleKind))
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
    
    var body: some View {
        Button(role: role, action: action) {
            imageAndLabelView()
                .frame(maxWidth: .infinity)
                .bold()
                .scale(.height(isMinimum: true), 40)
                .scale(.padding(.vertical), 10)
                .scale(.padding(.horizontal), 15)
                .background(color.bg)
                .foregroundStyle(color.tint)
                .tint(color.tint)
                .clipTo(RoundedRectangle(cornerRadius: CornerRadius.sm.rawValue))
        }
        .disabled(isDisabled)
        .buttonStyle(AppButtonStyle())
        .compositingGroup()
        .shadow()
    }
}

extension WideButton {
    enum Kind {
        case regular(CustomLabelStyle.Kind? = .iconTitle())
        case wrapped(CustomLabelStyle.Kind? = .iconTitle())
        case loading(String = .processing)
    }
    
    internal init(
        _ title: String,
        icon: Symbol? = nil,
        kind: Kind = .regular(),
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
        self.kind = .regular()
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
    WideButton("Delete", icon: .x, role: .destructive) {}
    WideButton("Cancel", role: .cancel) {}
    WideButton.loading("Testing Button") {}
}
