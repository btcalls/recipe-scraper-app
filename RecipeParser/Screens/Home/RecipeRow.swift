//
//  RecipeRow.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe
    
    @ScaledMetric private var spacing: CGFloat = 20
    @ScaledMetric private var bodySpacing: CGFloat = 5
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            CustomImage(kind: .url(recipe.imageURL))
                .frame(width: 80, height: 80)
                .clipTo(RoundedRectangle(cornerRadius: .sm))
            
            VStack(alignment: .leading, spacing: bodySpacing) {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(recipe.categoriesCuisinesLabel)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                    .lineLimit(1)
            }
            
            Symbol.bookmarkFill.image
                .font(.largeTitle)
                .imageScale(.small)
                .foregroundStyle(Color.yellow)
                .remove(if: !recipe.isFavorite)
        }
        .scale(.padding(.vertical), 10)
        .scale(.padding(.horizontal), 15)
        .background(Color.appBackground.brightness(0.1))
        .rounded(cornerRadius: .regular)
        .shadow()
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
