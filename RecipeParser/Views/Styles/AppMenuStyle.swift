//
//  AppMenuStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import SwiftUI

struct AppMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .scale(.padding(.vertical), 10)
            .scale(.padding(.horizontal), 15)
            .background(Color.appBackground)
            .foregroundStyle(Color.accentColor)
            .clipTo(.capsule)
            .shadow()
    }
}
