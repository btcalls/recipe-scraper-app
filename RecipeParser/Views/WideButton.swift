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
                    .tint(Color.white)
                
                Text(title)
            }
        }
    }
    
    var body: some View {
        Button(role: role, action: action) {
            imageAndLabelView()
                .frame(maxWidth: .infinity)
                .bold()
                .scale(.height(isMinimum: true), 45)
                .scale(.padding(.vertical), 5)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: CornerRadius.sm.rawValue))
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
    WideButton(.loading("Testing Button")) {}
}
