//
//  RecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/5/2025.
//

import SwiftUI

struct RecipeView: View {
    @Namespace var ingredientsID
    @Namespace var instructionsID
    
    var recipe: Recipe
    
    @ViewBuilder private func headerView(
        _ value: String,
        action: @escaping @MainActor () -> Void
    ) -> some View {
        Button(action: action) {
            Label(.link) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .labelStyle(CustomLabelStyle(.titleIcon(.body, .small)))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .tint(.primary)
        .background(Color.appBackground)
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
    
    @ViewBuilder private func timeView(_ measurement: Measurement<UnitDuration>,
                                       as label: String) -> some View {
        HStack(alignment: .center) {
            Text(label)
                .frame(width: 90, alignment: .leading)
            
            Text(measurement, format: .measurement(width: .wide))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .italic()
        }
    }
    
    @ViewBuilder private func navButtonsView() -> some View {
        VStack(spacing: 10) {
            Symbol.arrowUp.image
                .frame(width: 40, height: 40)
            
            Symbol.arrowDown.image
                .frame(width: 40, height: 40)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10, pinnedViews: .sectionHeaders) {
                        Section {
                            Text(recipe.cuisineCategory)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(recipe.detail)
                                .fontWeight(.light)
                            
                            Divider()
                                .asStandard()
                                .padding(.vertical, 5)
                            
                            VStack(alignment: .leading) {
                                timeView(recipe.prepTimeMeasurement, as: .prepTime)
                                timeView(recipe.cookTimeMeasurement, as: .cookTime)
                            }
                            
                            Divider()
                                .asStandard()
                                .padding(.vertical, 5)
                        } header: {
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appBackground)
                        
                        Section {
                            ForEach(recipe.ingredients) { ingredient in
                                ingredientView(ingredient)
                            }
                        } header: {
                            headerView(.ingredients) {
                                withAnimation {
                                    proxy.scrollTo(ingredientsID, anchor: .top)
                                }
                            }
                            .id(ingredientsID)
                        }
                        
                        Divider()
                            .asStandard()
                            .padding(.vertical, 5)
                        
                        Section {
                            ForEach(recipe.instructions, id: \.self) { instruction in
                                instructionsView(instruction)
                            }
                        } header: {
                            headerView(.instructions) {
                                withAnimation {
                                    proxy.scrollTo(instructionsID, anchor: .top)
                                }
                            }
                            .id(instructionsID)
                        }
                    }
                    .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                .padding(.bottom, 30)
            }
            
            navButtonsView()
                .background(Color.teal)
                .offset(x: -20, y: -30)
        }
        .background(Color.appBackground)
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
