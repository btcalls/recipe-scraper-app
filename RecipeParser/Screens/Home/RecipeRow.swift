//
//  RecipeRow.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe
    
    @EnvironmentObject private var coordinator: Coordinator
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    @ScaledMetric private var bodySpacing = Layout.Spacing.xSmall
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            CustomImage(kind: .url(recipe.imageURL))
                .scale(.square(), 80)
                .clipTo(
                    .rect(
                        corners: .concentric(minimum: .small),
                        isUniform: true
                    )
                )
            
            VStack(alignment: .leading, spacing: bodySpacing) {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(recipe.categoriesCuisinesLabel)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                    .lineLimit(2)
            }
            
            Symbol.bookmarkFill.image
                .font(.largeTitle)
                .imageScale(.small)
                .foregroundStyle(Color.yellow)
                .remove(if: !recipe.isFavorite)
        }
        .scale(.padding(.all), 15)
        .card(interactive: true)
        .onTapGesture {
            coordinator.push(page: .recipe(recipe))
        }
    }
}

extension RecipeRow {
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
}

#Preview {
    RecipeRow(recipe: MockService.shared.getRecipe())
}
