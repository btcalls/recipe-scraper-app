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

private struct DetailsView: View {
    let recipe: Recipe
    
    @ScaledMetric private var spacing: CGFloat = 10
    @ScaledMetric private var xOffset: CGFloat = -10
    @ScaledMetric private var yOffset: CGFloat = -55
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .top, spacing: spacing) {
                Text(recipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                IconButton(
                    recipe.isFavorite ? .bookmarkFill : .bookmark,
                    tint: .yellow,
                    size: .lg
                ) {
                    Task {
                        try? await onToggleFavorite(recipe)
                    }
                }
                .offset(x: xOffset, y: yOffset)
            }
            .imageScale(.large)
            
            Text(recipe.detail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
        }
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
    let value: String
    
    var body: some View {
        Text(value)
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
    
    @Namespace private var titleID
    @ScaledMetric private var height: CGFloat = 250
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var isStarted = false
    @State private var title: String = ""
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: .sectionHeaders
                ) {
                    CustomImage(kind: .url(recipe.imageURL, toCache: true))
                        .frame(height: height)
                        .clipShape(RoundedRectangle(cornerRadius: .lg))
                        .scale(.padding(.bottom), 15)
                        .shadow()
                    
                    DetailsView(recipe: recipe)
                        .id(titleID)
                    
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
                            IngredientView(value: $0.label)
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
                .scrollTargetLayout()
                .scale(.padding(.horizontal), 20)
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                BottomControlView {
                    Toggle($isStarted)
                        .toggleStyle(CustomToggleStyle(icons: (on: .x, off: .list)))
                }
                .scale(.padding(.trailing), 20)
            }
            .fullScreenCover(isPresented: $isStarted) {
                InstructionsView(items: recipe.instructions)
            }
        }
        .background(Color.appBackground)
        .navigationTitle(title)
        .scrollBounceBehavior(.basedOnSize)
        .onScrollTargetVisibilityChange(idType: Namespace.ID.self) { ids in
            withAnimation {
                title = ids.contains { $0 == titleID } ? "" : recipe.name
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
    RecipeView(MockService.shared.getRecipe())
}
