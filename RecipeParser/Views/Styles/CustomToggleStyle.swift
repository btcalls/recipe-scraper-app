//
//  CustomToggleStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/7/2025.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var icons: (on: Symbol, off: Symbol) = (.success, .checkmarkCircle)
    
    func makeBody(configuration: Configuration) -> some View {
        IconButton(
            configuration.isOn ? icons.on : icons.off
        ) {
            configuration.isOn.toggle()
        }
    }
}
