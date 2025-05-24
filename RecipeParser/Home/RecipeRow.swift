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
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Gradient(colors: [.teal, .purple]))
        .rounded(cornerRadius: .regular)
        .shadow()
    }
}

#Preview {
    RecipeRow(recipe: .sample)
}
