//
//  RecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/5/2025.
//

import SwiftUI

struct RecipeView: View {
    @Namespace var titleID
    @Namespace var ingredientsID
    @Namespace var instructionsID
    
    var recipe: Recipe
    
    @State private var currentID: Namespace.ID? = nil
    @ScaledMetric private var buttonXOffset: CGFloat = -20
    @ScaledMetric private var bulletFont: CGFloat = 7.5
    @ScaledMetric private var bulletYOffset: CGFloat = 7.5
    @ScaledMetric private var spacing: CGFloat = 10
    
    private var ids: [Namespace.ID] {
        return [titleID, ingredientsID, instructionsID]
    }
    
    @ViewBuilder private func headerView(_ value: String) -> some View {
        Text(value)
            .font(.title2)
            .fontWeight(.semibold)
            .labelStyle(CustomLabelStyle(.titleIcon(.body, .small)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .scale(.padding(.vertical), 10)
            .background(Color.appBackground)
    }
    
    @ViewBuilder private func ingredientView(_ ingredient: Ingredient) -> some View {
        Text(ingredient.label)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.light)
    }
    
    @ViewBuilder private func instructionsView(_ value: String) -> some View {
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
    
    @ViewBuilder private func timeView(_ measurement: Measurement<UnitDuration>,
                                       as label: String) -> some View {
        HStack(alignment: .center) {
            Text(label)
                .scale(.width(), 90)
                .frame(alignment: .leading)
            
            Text(measurement, format: .measurement(width: .wide))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .italic()
        }
    }
    
    @ViewBuilder private func scrollToView(_ proxy: ScrollViewProxy) -> some View {
        HStack(spacing: spacing) {
            CompactButton(.init(.arrowUp)) {
                withAnimation {
                    if let id = currentID, let prevID = ids.prev(id) {
                        currentID = prevID
                    } else {
                        currentID = titleID
                    }
                    
                    proxy.scrollTo(currentID, anchor: .top)
                }
            }
            .transition(.opacity)
            .hidden(if: currentID == titleID || currentID == nil)
            
            CompactButton(.init(.arrowDown)) {
                withAnimation {
                    if let id = currentID, let nextID = ids.next(id) {
                        currentID = nextID
                    } else {
                        currentID = ingredientsID
                    }
                    
                    proxy.scrollTo(currentID, anchor: .top)
                }
            }
            .transition(.opacity)
            .hidden(if: currentID == instructionsID, remove: true)
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        spacing: spacing,
                        pinnedViews: .sectionHeaders
                    ) {
                        Section {
                            Text(recipe.cuisineCategory)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                            
                            Text(recipe.detail)
                                .fontWeight(.light)
                            
                            Divider()
                                .asStandard()
                                .scale(.padding(.vertical), 5)
                            
                            VStack(alignment: .leading) {
                                timeView(recipe.prepTimeMeasurement, as: .prepTime)
                                timeView(recipe.cookTimeMeasurement, as: .cookTime)
                            }
                            
                            Divider()
                                .asStandard()
                                .scale(.padding(.vertical), 5)
                        } header: {
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .scale(.padding(.vertical), 10)
                                .id(titleID)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appBackground)
                        
                        Section {
                            ForEach(recipe.ingredients) {
                                ingredientView($0)
                            }
                        } header: {
                            headerView(.ingredients)
                                .id(ingredientsID)
                        }
                        
                        Divider()
                            .asStandard()
                            .scale(.padding(.vertical), 5)
                        
                        Section {
                            ForEach(recipe.instructions, id: \.self) {
                                instructionsView($0)
                            }
                        } header: {
                            headerView(.instructions)
                                .id(instructionsID)
                        }
                    }
                    .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                .scale(.padding(.bottom), 55)
                
                scrollToView(proxy)
                    .offset(x: buttonXOffset, y: 0)
            }
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
    RecipeView(.sample)
}
