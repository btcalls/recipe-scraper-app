//
//  CustomButtonStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    /// Controls the brightness of the button style based on whether the button is currently being pressed.
    /// - Parameter isPressed: Flag whether the button is pressed or not.
    /// - Returns: Brightness value.
    private func brightness(_ isPressed: Bool) -> Double {
        if !isEnabled {
            return -0.25
        }
        
        return isPressed ? -0.10 : 0
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(brightness(configuration.isPressed))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(
                .customInteractiveSpring,
                value: configuration.isPressed
            )
    }
}

#Preview {
    @Previewable @State var isFavorite: Bool = false
    
    Toggle($isFavorite)
        .toggleStyle(CustomToggleStyle(icons: (on: .bookmarkFill,
                                               off: .bookmark)))
    
    WideButton("Test") {}
    WideButton("Test") {}
        .disabled(true)
    
    IconButton(.x) {}
    IconButton(.x) {}
        .disabled(true)
}
