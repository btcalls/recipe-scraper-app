//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var viewModel = HomeViewModel()
    @Query(sort: \Recipe.createdOn, order: .reverse) private var items: [Recipe]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { recipe in
                    NavigationLink {
                        RecipeView(recipe)
                    } label: {
                        RecipeRow(recipe)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .refreshable {}
            .navigationTitle(String.yourRecipes)
            .emptyView(
                if: items.isEmpty,
                label: Label(.noRecipes, symbol: .forkKnife),
                description: .noRecipesDescription
            )
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(.shared(inMemoryOnly: true))
}
