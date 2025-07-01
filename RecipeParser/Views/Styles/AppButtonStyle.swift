//
//  AppButtonStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
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
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    WideButton("Test") {}
    WideButton("Test") {}
        .disabled(true)
    
    IconButton(.x) {}
    IconButton(.x) {}
        .disabled(true)
}
