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

private struct NameFavoriteView: View {
    let recipe: Recipe
    
    @ScaledMetric private var spacing: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            Text(recipe.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            IconButton(
                recipe.isFavorite ? .bookmarkFill : .bookmark,
                tint: .yellow,
                kind: .muted
            ) {
                Task {
                    try? await onToggleFavorite(recipe)
                }
            }
        }
        .font(.largeTitle)
        .imageScale(.medium)
        .fontWeight(.bold)
        .scale(.padding(.bottom), 10)
    }
    
    @MainActor
    private func onToggleFavorite(_ recipe: Recipe) async throws {
        let actor = DatabaseActor(modelContainer: .shared())
        
        recipe.isFavorite.toggle()
        recipe.modifiedOn = Date()
        
        try await actor.save(model: recipe)
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
    
    @Namespace private var headerID
    @Namespace private var ingredientsID
    @Namespace private var instructionsID
    @ScaledMetric private var height: CGFloat = 250
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var currentID: Namespace.ID? = nil
    @State private var title: String = ""
    
    private var ids: [Namespace.ID] {
        return [headerID, ingredientsID, instructionsID]
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                CustomImage(kind: .url(recipe.imageURL, toCache: true))
                    .frame(height: height)
                    .clipShape(.rect)
                
                LazyVStack(
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: .sectionHeaders
                ) {
                    NameFavoriteView(recipe: recipe)
                        .id(headerID)
                    
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
                    
                    Section {
                        ForEach(recipe.ingredients) {
                            IngredientView(ingredient: $0)
                        }
                    } header: {
                        HeaderView(value: .ingredients)
                            .id(ingredientsID)
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
                            .id(instructionsID)
                    }
                }
                .padding()
                .scrollTargetLayout()
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                BottomControlView {
                    IconButton(.arrowUp) {
                        currentID = ids.cycle(currentID,
                                              fallback: headerID,
                                              reverse: true)
                        
                        withAnimation {
                            proxy.scrollTo(currentID, anchor: .top)
                        }
                    }
                    .disabled(currentID == nil || currentID == headerID)
                    
                    IconButton(.arrowDown) {
                        currentID = ids.cycle(currentID,
                                              fallback: ingredientsID)
                        
                        withAnimation {
                            proxy.scrollTo(currentID, anchor: .top)
                        }
                    }
                    .disabled(currentID == instructionsID)
                }
                .buttonStyle(AppButtonStyle())
                .scale(.padding(.trailing), 10)
            }
        }
        .background(Color.appBackground)
        .navigationTitle(title)
        .scrollBounceBehavior(.basedOnSize)
        .onScrollTargetVisibilityChange(idType: Namespace.ID.self) { ids in
            withAnimation {
                title = ids.contains { $0 == headerID } ? "" : recipe.name
                
                if let first = ids.first {
                    currentID = first
                }
            }
        }
    }
}

extension RecipeView {
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
}

//#Preview {
//    RecipeView(MockService.shared.getRecipe())
//}

#Preview {
//    RecipeView(MockService.shared.getRecipe())
    NavigationStack {
        RecipeRow(MockService.shared.getRecipe())
            .navigate(to: RecipeView(MockService.shared.getRecipe()))
    }
}
