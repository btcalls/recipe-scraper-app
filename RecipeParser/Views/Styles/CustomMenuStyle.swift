//
//  CustomMenuStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import SwiftUI

struct CustomMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .scale(.padding(.vertical), 10)
            .scale(.padding(.horizontal), 15)
            .background(Color.appBackground.brightness(0.1))
            .foregroundStyle(Color.accentColor)
            .clipTo(.capsule)
            .shadow()
            .buttonStyle(CustomButtonStyle())
    }
}

#Preview {
    Menu("Test") {
        Button(action: { }) { Text("Test") }
    }
    .menuStyle(CustomMenuStyle())
}
