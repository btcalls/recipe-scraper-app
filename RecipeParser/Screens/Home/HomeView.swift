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
    @Query(sort: \Recipe.createdOn, order: .reverse) private var items: [Recipe]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.id) { recipe in
                    RecipeRow(recipe)
                        .overlay {
                            NavigationLink {
                                RecipeView(recipe)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
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
                label: Label(.noRecipes, sfSymbol: .forkKnife),
                description: .noRecipesDescription
            )
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(.shared(inMemoryOnly: true))
}
