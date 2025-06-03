//
//  RecipeListView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI

struct RecipeListView: View {
    //    @Query(sort: \Recipe.createdOn, order: .reverse) private var items: [Recipe]
    private var items: [Recipe] = [.sample]
    
    var body: some View {
        ScrollView {
            ForEach(items, id: \.id) { recipe in
                RecipeRow(recipe)
                    .navigate(to: RecipeView(recipe))
            }
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .listStyle(.plain)
        .refreshable {}
        .emptyView(
            if: items.isEmpty,
            label: Label(.noRecipes, sfSymbol: .forkKnife),
            description: {
                Text(String.noRecipesDescription)
            }
        )
    }
}

#Preview {
    RecipeListView()
}
