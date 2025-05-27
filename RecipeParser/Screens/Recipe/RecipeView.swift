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
    
    private func measurement(of value: Double) -> String {
        let measurement = Measurement(value: value, unit: UnitDuration.minutes)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        
        return formatter.string(from: measurement)
    }
    
    @ViewBuilder private func timeView(_ value: Double, as label: String) -> some View {
        HStack(alignment: .center) {
            Text(label)
                .frame(width: 90, alignment: .leading)
            
            Text(measurement(of: value))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .italic()
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    Text(recipe.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(recipe.cuisineCategory)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(recipe.detail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.light)
                    
                    Divider()
                        .asStandard()
                        .padding(.vertical, 5)
                    
                    VStack(alignment: .leading) {
                        timeView(recipe.prepTime, as: .prepTime)
                        timeView(recipe.cookTime, as: .cookTime)
                    }
                    
                    Divider()
                        .asStandard()
                        .padding(.vertical, 5)
                    
                    headerView(.ingredients)
                    
                    ForEach(recipe.ingredients) { ingredient in
                        ingredientView(ingredient)
                    }
                    
                    Divider()
                        .asStandard()
                        .padding(.vertical, 5)
                    
                    headerView(.instructions)
                    
                    ForEach(recipe.instructions, id: \.self) { instruction in
                        instructionsView(instruction)
                    }
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding(.bottom, 30)
            .background(Color.appBackground)
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
