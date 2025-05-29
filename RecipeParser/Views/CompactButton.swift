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
    var action: @MainActor () -> Void
    
    var body: some View {
        Button(action: action) {
            icon.sfSymbol.image
        }
        .scale(.heightWidth(), value: 45)
        .background(color.brightness(0.1))
        .tint(icon.tint)
        .clipTo(.circle)
        .shadow()
    }
}

extension CompactButton {
    struct Icon {
        let sfSymbol: Symbol
        let tint: Color
    }
    
    init(
        _ icon: Icon,
        color: Color = .appBackground,
        action: @escaping @MainActor () -> Void
    ) {
        self.icon = icon
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
    CompactButton(.init(.plus)) {}
}
