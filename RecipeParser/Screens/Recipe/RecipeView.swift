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
                .fontWeight(.light)
                .italic()
                .frame(maxWidth: .infinity, alignment: .leading)
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

private struct HeaderView: View {
    let value: String
    
    var body: some View {
        Text(value)
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .scale(.padding(.vertical), 10)
    }
}

private struct InstructionSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        Section {
            BulletedList(items: items)
        } header: {
            HeaderView(value: title)
        }
    }
}

struct RecipeView: View {
    var recipe: Recipe
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var coordinator: Coordinator
    @Namespace private var titleID
    @ScaledMetric private var spacing = Layout.Scaled.interItem
    @State private var isCookCompleted = false
    @State private var isCalendarDisplayed = false
    @State private var title: String = ""
    @State private var viewState = ViewState()
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button(recipe.isFavorite ? .bookmarkFill : .bookmark) {
                Task {
                    try? await onToggleFavorite()
                }
            }
        }
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItemGroup(placement: .bottomBar) {
            Button(.list) {
                coordinator
                    .presentSheet(.instructions(recipe.detailedInstructions, {
                        Task {
                            try? await onCompleteRecipe()
                        }
                    }))
            }
            
            Button(.checkmark, role: .confirm) {
                isCookCompleted.toggle()
            }
        }
    }
    
    var body: some View {
        LoadableView(viewState: viewState) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .center, spacing: spacing) {
                        RecipeInfoView(recipe: recipe)
                            .id(recipe.name)
                        
                        TimeDetailsView(recipe: recipe)
                        
                        Section {
                            BulletedList(items: recipe.ingredients.map { $0.label })
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
                    .scale(.padding(.bottom), 40)
                }
                .toolbar {
                    toolbarContent
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
                            
                            isCalendarDisplayed = false
                        }
                    }
                }
            }
            .appBackground()
            .navigationTitle(title)
            .scrollBounceBehavior(.basedOnSize)
            .onScrollTargetVisibilityChange(
                idType: String.self,
                threshold: 0.25
            ) { ids in
                title = ids.contains { $0 == recipe.name } ? "" : recipe.name
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
            viewState.toast = .failure(.error(e))
        }
    }

    private func onToggleFavorite() async throws {
        do {
            let actor = DatabaseActor(modelContainer: .shared())
            
            recipe.isFavorite.toggle()
            
            try await actor.save(recipe: recipe)
        } catch(let e) {
            viewState.toast = .failure(.error(e))
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
            viewState.toast = .failure(.error(e))
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
