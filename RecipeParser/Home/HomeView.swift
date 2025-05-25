//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @Query private var items: [Recipe]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    RecipeRow(recipe: item)
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
}
