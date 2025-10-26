//
//  NavigableViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct NavigableViewModifier<Value, S: RoundedRectangularShape>: ViewModifier where Value : Hashable {
    var value: Value
    var shape: S
    
    @Environment(\.isEnabled) private var isEnabled
    
    func body(content: Content) -> some View {
        NavigationLink(value: value) {
            content
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .buttonStyle(.plain)
        .containerShape(shape)
        .glassEffect(.regular.interactive(isEnabled), in: shape)
    }
}

#Preview {
    NavigationStack {
        RecipeRow(MockService().getRecipe())
            .asLink(value: String.seeAll)
    }
}
