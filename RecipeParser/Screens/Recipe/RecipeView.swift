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
    
    var onAction: @MainActor () -> Void
    
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
                    onAction()
                }
                .offset(x: xOffset, y: yOffset)
            }
            .imageScale(.large)
            
            Text(recipe.detail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
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
    
    @Environment(\.presentationMode) private var presentationMode
    @Namespace private var titleID
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var isCookCompleted = false
    @State private var isStarted = false
    @State private var title: String = ""
    @State private var viewState = ViewState()
    
    var body: some View {
        LoadableView(viewState: viewState) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: .sectionHeaders
                    ) {
                        CustomImage(kind: .url(recipe.imageURL, toCache: true))
                            .scale(.height(), 300)
                            .fitToAspectRatio(.fourToThree)
                            .clipTo(RoundedRectangle(cornerRadius: .lg))
                            .scale(.padding(.vertical), 10)
                            
                        DetailsView(recipe: recipe) {
                            Task {
                                try? await onToggleFavorite()
                            }
                        }
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
                        IconButton(.checkmark, size: .lg) {
                            isCookCompleted.toggle()
                        }
                        .remove(if: title.isEmpty)
                        
                        Toggle($isStarted)
                            .toggleStyle(CustomToggleStyle(icons: (on: .x, off: .list)))
                        
                        IconButton(
                            recipe.isFavorite ? .bookmarkFill : .bookmark,
                            tint: .yellow
                        ) {
                            Task {
                                try? await onToggleFavorite()
                            }
                        }
                        .remove(if: title.isEmpty)
                    }
                    .animation(.customInteractiveSpring, value: title)
                    .scale(.padding(.trailing), 20)
                }
                .fullScreenCover(isPresented: $isStarted) {
                    InstructionsView(items: recipe.instructions) {
                        Task {
                            try? await onCompleteRecipe()
                        }
                    }
                }
                .alert(String.success, isPresented: $isCookCompleted) {
                    Button(String.markComplete) {
                        Task {
                            try? await onCompleteRecipe()
                        }
                    }
                    Button(String.cancel, role: .cancel) {}
                } message: {
                    Text(String.cookCompleteConfirmation)
                }
            }
            .background(Color.appBackground)
            .navigationTitle(title)
            .scrollBounceBehavior(.basedOnSize)
            .onScrollTargetVisibilityChange(idType: Namespace.ID.self) { ids in
                title = ids.contains { $0 == titleID } ? "" : recipe.name
            }
        }
    }
    
    private func onCompleteRecipe() async throws {
        do {
            let actor = DatabaseActor(modelContainer: .shared())
            
            recipe.timesCompleted += 1
            
            try await actor.save(recipe: recipe)
            
            presentationMode.wrappedValue.dismiss()
        } catch(let e) {
            viewState.toast = .error(.error(e))
        }
    }

    private func onToggleFavorite() async throws {
        do {
            let actor = DatabaseActor(modelContainer: .shared())
            
            recipe.isFavorite.toggle()
            
            try await actor.save(recipe: recipe)
        } catch(let e) {
            viewState.toast = .error(.error(e))
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
