//
//  PressableStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.15 : 0)
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
