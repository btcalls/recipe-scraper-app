//
//  CompactButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

struct IconButton: AppButton {
    typealias Display = Symbol
    typealias ButtonKind = Kind
    
    var display: Symbol
    var kind: Kind = .regular
    var size: Size = .regular
    var action: @MainActor () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var glass: Glass {
        switch kind {
        case .regular:
            return .regular
        
        case .muted:
            return .clear
        }
    }
    private var imageScale: Image.Scale {
        switch size {
        case .regular:
            return .medium
            
        case .lg:
            return .large
        }
    }
    
    var body: some View {
        Button(action: action) {
            display.image
                .fontWeight(.medium)
                .imageScale(imageScale)
                .contentTransition(.symbolEffect)
        }
        .padding()
        .glassEffect(glass.interactive(isEnabled), in: .circle)
    }
}

extension IconButton {
    enum Kind {
        case regular
        case muted
    }
    
    enum Size: CGFloat {
        case regular = 45
        case lg = 60
    }
    
    init(
        _ display: Symbol,
        kind: Kind = .regular,
        size: Size = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.display = display
        self.kind = kind
        self.size = size
        self.action = action
    }
}

#Preview {
    @Previewable @State var isEnabled = false
    
    IconButton(.checkmark, size: .lg) {}
    IconButton(isEnabled ? .bookmarkFill : .bookmark) {
        isEnabled.toggle()
    }
    .tint(.yellow)
    IconButton(.x, kind: .muted) {}
        .disabled(true)
}
