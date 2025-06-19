//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

struct WideButton: View {
    var state: State
    var role: ButtonRole? = .none
    var action: @MainActor () -> Void
    
    @ScaledMetric private var spacing: CGFloat = 8
    
    private var isDisabled: Bool {
        switch state {
        case .idle(_, _):
            return false
        
        case .loading(_:):
            return true
        }
    }
    private var color: (bg: Color, tint: Color) {
        if case .loading(_:) = state {
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
        switch state {
        case .idle(let title, let sfSymbol):
            if let sfSymbol {
                Label(title, sfSymbol: sfSymbol)
                    .labelStyle(CustomLabelStyle())
            } else {
                Text(title)
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
                .scale(.padding(.horizontal), 5)
                .scale(.padding(.vertical), 2.5)
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
    enum State {
        case idle(String, sfSymbol: Symbol? = nil)
        case loading(String = .processing)
    }
    
    internal init(
        _ state: State,
        role: ButtonRole? = .none,
        action: @escaping @MainActor () -> Void
    ) {
        self.state = state
        self.role = role
        self.action = action
    }
    
    internal init(
        _ title: String,
        role: ButtonRole? = .none,
        action: @escaping @MainActor () -> Void
    ) {
        self.state = .idle(title)
        self.role = role
        self.action = action
    }
}

#Preview {
    WideButton("Sample") {}
    WideButton(.idle("Delete", sfSymbol: .x), role: .destructive) {}
    WideButton(.idle("Cancel"), role: .cancel) {}
    WideButton(.loading("Testing Button")) {}
}
