//
//  CompactButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

struct IconButton: View {
    var icon: Symbol
    var tint: Color = .primary
    var kind: Kind = .regular
    var action: @MainActor () -> Void
    
    private var isMuted: Bool {
        return kind == .muted
    }
    private var bg: some View {
        let bgColor = isMuted ? Color.clear : .appBackground
        
        return bgColor.brightness(isMuted ? 0 : 0.1)
    }
    
    @ViewBuilder private func buttonView() -> some View {
        Button(action: action) {
            icon.image
                .fontWeight(.medium)
                .scale(.heightWidth(), 45)
                .background(bg)
                .foregroundStyle(tint)
                .clipTo(.circle)
        }
        .buttonStyle(AppButtonStyle())
    }
    
    var body: some View {
        switch kind {
        case .regular:
            buttonView()
                .shadow()
        
        case .muted:
            buttonView()
        }
    }
}

extension IconButton {
    enum Kind {
        case regular
        case muted
    }
    
    init(
        _ icon: Symbol,
        tint: Color = .primary,
        kind: Kind = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.icon = icon
        self.tint = tint
        self.kind = kind
        self.action = action
    }
}

#Preview {
    IconButton(.plus) {}
    IconButton(.x, tint: .red, kind: .muted) {}
}
