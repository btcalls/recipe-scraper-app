//
//  CompactButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

struct CompactButton: View {
    var icon: Icon = .init(.plus)
    var color: Color = .appBackground
    var kind: Kind = .regular
    var action: @MainActor () -> Void
    
    private var isMuted: Bool {
        return kind == .muted
    }
    private var bg: some View {
        let bgColor = isMuted ? Color.clear : color
        
        return bgColor.brightness(isMuted ? 0 : 0.1)
    }
    
    @ViewBuilder private func buttonView() -> some View {
        Button(action: action) {
            icon.sfSymbol.image
                .scale(.heightWidth(), 45)
                .background(bg)
                .tint(icon.tint)
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

extension CompactButton {
    struct Icon {
        let sfSymbol: Symbol
        let tint: Color
    }
    
    enum Kind {
        case regular
        case muted
    }
    
    init(
        _ icon: Icon,
        color: Color = .appBackground,
        kind: Kind = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.kind = kind
        self.action = action
    }
}

extension CompactButton.Icon {
    init(_ sfSymbol: Symbol, tint: Color = .primary) {
        self.sfSymbol = sfSymbol
        self.tint = tint
    }
}

#Preview {
    CompactButton(.init(.plus), color: .orange) {}
    CompactButton(.init(.x), kind: .muted) {}
}
