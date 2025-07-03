//
//  NavigableViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct NavigableViewModifier<Destination>: ViewModifier where Destination : View {
    @ViewBuilder var destination: Destination
    
    func body(content: Content) -> some View {
        NavigationLink {
            destination
        } label: {
            content
        }
        .buttonStyle(CustomButtonStyle())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
