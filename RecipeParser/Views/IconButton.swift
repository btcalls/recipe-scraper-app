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
    var size: IconButton.Size
    var tint: Color?
    var action: @MainActor () -> Void
    
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
                .scale(.heightWidth(), size.rawValue)
                .background { bg }
                .foregroundStyle(tint ?? Color.appForeground)
                .clipTo(.circle)
                .contentTransition(.symbolEffect)
        }
        .buttonStyle(CustomButtonStyle())
    }
}

struct IconButton: AppButton {
    typealias Display = Symbol
    typealias ButtonKind = Kind
    
    var display: Symbol
    var kind: Kind = .regular
    var size: Size = .regular
    var tint: Color? = .accentColor
    var action: @MainActor () -> Void
    
    var body: some View {
        switch kind {
        case .regular:
            ButtonView(
                display: display,
                bg: Color.appBackground.brightness(0.1),
                size: size,
                tint: tint,
                action: action
            )
                .shadow()
        
        case .muted:
            ButtonView(
                display: display,
                bg: Color.clear,
                size: size,
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
    
    enum Size: CGFloat {
        case regular = 45
        case lg = 60
    }
    
    init(
        _ display: Symbol,
        tint: Color = .accentColor,
        kind: Kind = .regular,
        size: Size = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.display = display
        self.tint = tint
        self.kind = kind
        self.size = size
        self.action = action
    }
}

#Preview {
    @Previewable @State var isEnabled = false
    
    IconButton(.bookmark, size: .lg) {}
    IconButton(isEnabled ? .bookmarkFill : .bookmark, tint: .orange) {
        isEnabled.toggle()
    }
    IconButton(.x, tint: .red, kind: .muted) {}
}
