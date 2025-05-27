//
//  RecipeRow.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            CustomImage(content: .url(recipe.imageURL))
                .frame(width: 80, height: 80)
                .clipTo(shape: Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("\(recipe.cuisine) • \(recipe.category)")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
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
