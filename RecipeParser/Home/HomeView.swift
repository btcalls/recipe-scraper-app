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
//    @Query private var items: [Recipe] = [.sample]
    private var items: [Recipe] = [.sample, .sample, .sample]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    RecipeRow(recipe: item)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .refreshable {}
            .navigationTitle(String.yourRecipes)
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        String.noRecipes,
                        systemImage: Symbol.forkKnife.rawValue,
                        description: Text(String.noRecipesDescription)
                    )
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
