//
//  RecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/5/2025.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    
    @ViewBuilder private func headerView(_ value: String) -> some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.vertical, 10)
    }
    
    @ViewBuilder private func ingredientView(_ ingredient: Ingredient) -> some View {
        Text(ingredient.label)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.light)
    }
    
    @ViewBuilder private func instructionsView(_ value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Symbol.bullet.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 5, height: 5)
                .offset(y: 7.5)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 10) {
                        Text(recipe.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("\(recipe.cuisine) • \(recipe.category)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(recipe.detail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.light)
                        
                        headerView(.ingredients)
                        
                        ForEach(recipe.ingredients) { ingredient in
                            ingredientView(ingredient)
                        }
                        
                        headerView(.instructions)
                        
                        ForEach(recipe.instructions, id: \.self) { instruction in
                            instructionsView(instruction)
                        }
                    }
                    .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                .padding(.bottom, 30)
            }
        }
    }
}

extension RecipeView {
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
}

#Preview {
    RecipeView(recipe: Recipe.sample)
}
