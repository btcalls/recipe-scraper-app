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

private struct TimeDetailsView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
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
        }
    }
}

private struct DetailsView: View {
    let recipe: Recipe
        
    @ScaledMetric private var spacing: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(recipe.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(recipe.detail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .scale(.padding(.vertical), 10)
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
            .lineLimit(2)
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

private struct InstructionSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        Section {
            ForEach(items, id: \.self) {
                InstructionView(value: $0)
            }
        } header: {
            HeaderView(value: title)
        }
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
    @State private var isCalendarDisplayed = false
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
                            .padding(.vertical, 10)
                            
                        DetailsView(recipe: recipe)
                            .id(titleID)
                        
                        TimeDetailsView(recipe: recipe)
                        
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
                        
                        ForEach(recipe.detailedInstructions, id: \.self.title) { (title, items) in
                            InstructionSection(title: title, items: items)
                        }
                    }
                    .scrollTargetLayout()
                    .scale(.padding(.horizontal), 20)
                    .scrollEdgeEffectStyle(.hard, for: .all)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Toggle($isCalendarDisplayed)
                            .toggleStyle(CustomToggleStyle(icons: (on: .x, off: .calendar)))
                    
                        Button(recipe.isFavorite ? .bookmarkFill : .bookmark) {
                            Task {
                                try? await onToggleFavorite()
                            }
                        }
                    }
                    
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        Toggle($isStarted)
                            .toggleStyle(CustomToggleStyle(icons: (on: .x, off: .list)))
                        
                        Button(.checkmark, role: .confirm) {
                            isCookCompleted.toggle()
                        }
                    }
                }
                .fullScreenCover(isPresented: $isStarted) {
                    InstructionsView(items: recipe.detailedInstructions) {
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
                .sheet(isPresented: $isCalendarDisplayed) {
                    // TODO:
                } content: {
                    Button("Add") {
                        Task {
                            try? await onScheduleRecipe()
                        }
                    }
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
    
    private func onScheduleRecipe() async throws {
        do {
            let actor = DatabaseActor(modelContainer: .shared())
            let model = RecipeWeekMenu(
                recipeID: recipe.id,
                name: recipe.name,
                imageURL: recipe.imageURL,
                date: Date()
            )
            
            try await actor.save(model: model)
            
            // TEMP
            viewState.toast = .success("Successfully set.")
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
    NavigationStack {
        RecipeView(MockService.shared.getRecipe())
    }
}
