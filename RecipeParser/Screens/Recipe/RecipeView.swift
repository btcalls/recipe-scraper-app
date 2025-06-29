//
//  RecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/5/2025.
//

import SwiftUI

private struct TimeView: View {
    let measurement: Measurement<UnitDuration>
    let label: String

    var body: some View {
        HStack(alignment: .center) {
            Text(label)
                .scale(.width(), 90)
                .frame(alignment: .leading)
            
            Text(measurement, format: .measurement(width: .abbreviated))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .italic()
        }
    }
}

private struct HeaderView: View {
    let value: String
    
    var body: some View {
        Text(value)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .scale(.padding(.vertical), 10)
            .background(Color.appBackground)
    }
}

private struct IngredientView: View {
    let ingredient: Ingredient
    
    var body: some View {
        Text(ingredient.label)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.light)
    }
}

private struct InstructionView: View {
    let value: String
    
    @ScaledMetric private var bulletFont: CGFloat = 7.5
    @ScaledMetric private var bulletYOffset: CGFloat = 7.5
    @ScaledMetric private var spacing: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            Symbol.bullet.image
                .font(.system(size: bulletFont))
                .imageScale(.small)
                .offset(y: bulletYOffset)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
        }
    }
}

struct RecipeView: View {
    var recipe: Recipe
    
    @ScaledMetric private var spacing: CGFloat = 10
    
    var body: some View {
        ScrollView {
            CustomImage(kind: .url(recipe.imageURL, toCache: true))
                .frame(height: 300)
                .clipShape(.rect)
            
            LazyVStack(
                alignment: .leading,
                spacing: spacing,
                pinnedViews: .sectionHeaders
            ) {
                Section {
                    Text(recipe.detail)
                        .fontWeight(.light)
                    
                    Divider()
                        .asStandard()
                        .scale(.padding(.vertical), 5)
                    
                    VStack(alignment: .leading) {
                        TimeView(measurement: recipe.prepTimeMeasurement,
                                 label: .prepTime)
                        TimeView(measurement: recipe.cookTimeMeasurement,
                                 label: .cookTime)
                    }
                    
                    Divider()
                        .asStandard()
                        .scale(.padding(.vertical), 5)
                } header: {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scale(.padding(.vertical), 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appBackground)
                
                Section {
                    ForEach(recipe.ingredients) {
                        IngredientView(ingredient: $0)
                    }
                } header: {
                    HeaderView(value: .ingredients)
                }
                
                Divider()
                    .asStandard()
                    .scale(.padding(.vertical), 5)
                
                Section {
                    ForEach(recipe.instructions, id: \.self) {
                        InstructionView(value: $0)
                    }
                } header: {
                    HeaderView(value: .instructions)
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
    }
}

extension RecipeView {
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
}

#Preview {
    RecipeView(MockService.shared.getRecipe())
}
