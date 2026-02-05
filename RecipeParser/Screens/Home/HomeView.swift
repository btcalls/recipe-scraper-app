//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @ScaledMetric private var height: CGFloat = 275
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    
    private var isEmpty = Recipe.count() == 0
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if !isEmpty {
            ToolbarItem(placement: .confirmationAction) {
                Button(.plus, role: .confirm) {
                    coordinator.presentSheet(.browser)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: spacing) {
                CustomButton(
                    display: (.seeAll, .chevronRightCircle),
                    kind: .regular,
                    role: .confirm) {
                        coordinator.push(page: .recipes)
                    }
                    .remove(if: isEmpty)
                
                RecipeListView(view: .first(3))
                
                Spacer()
            }
            .padding()
        }
        .appBackground()
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            toolbarContent
        }
        .emptyView(
            if: isEmpty,
            label: Label(.noRecipes, sfSymbol: .forkKnife),
            description: {
                Text(String.noRecipesDescription)
            }
        ) {
            CustomButton(.addRecipe, icon: .plus, role: .confirm) {
                coordinator.presentSheet(.browser)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(MockService.shared.modelContainer(withSample: true))
    }
}
