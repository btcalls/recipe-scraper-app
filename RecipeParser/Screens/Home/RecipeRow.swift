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
            CustomImage(content: .url(recipe.imageURL))
                .frame(width: 80, height: 80)
                .clipTo(Circle())
            
            VStack(alignment: .leading, spacing: bodySpacing) {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(recipe.cuisineCategory)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .scale(.padding(.vertical), 15)
        .scale(.padding(.horizontal), 20)
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
    RecipeRow(recipe: .sample)
}
