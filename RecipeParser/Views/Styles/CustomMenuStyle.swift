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
            .buttonStyle(.glass)
            .padding()
    }
}

#Preview {
    Menu("Test") {
        Button(action: { }) { Text("Menu 1") }
        Button(action: { }) { Text("Menu 2") }
    }
    .menuStyle(CustomMenuStyle())
}
