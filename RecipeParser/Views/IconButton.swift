//
//  CompactButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

private struct ButtonView<V>: View where V : View {
    var display: IconButton.Display
    var bg: V
    var tint: Color?
    var action: @MainActor () -> Void
    
    var body: some View {
        Button(action: action) {
            display.image
                .fontWeight(.medium)
                .scale(.heightWidth(), 45)
                .background { bg }
                .foregroundStyle(tint ?? Color.appForeground)
                .clipTo(.circle)
        }
        .buttonStyle(CustomButtonStyle())
    }
}

struct IconButton: AppButton {
    typealias Display = Symbol
    typealias ButtonKind = Kind
    
    var display: Symbol
    var kind: Kind = .regular
    var tint: Color? = .primary
    var action: @MainActor () -> Void
    
    var body: some View {
        switch kind {
        case .regular:
            ButtonView(
                display: display,
                bg: Color.appBackground.brightness(0.1),
                tint: tint,
                action: action
            )
                .shadow()
        
        case .muted:
            ButtonView(
                display: display,
                bg: Color.clear,
                tint: tint,
                action: action
            )
        }
    }
}

extension IconButton {
    enum Kind {
        case regular
        case muted
    }
    
    init(
        _ display: Symbol,
        tint: Color = .primary,
        kind: Kind = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.display = display
        self.tint = tint
        self.kind = kind
        self.action = action
    }
}

#Preview {
    IconButton(.plus) {}
    IconButton(.bookmark, tint: .orange) {}
    IconButton(.x, tint: .red, kind: .muted) {}
}
