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
    
    @State private var isBrowserPresented = false
    
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
            .navigationTitle("")
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isBrowserPresented = true
                        } label: {
                            Symbol.plus.image
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text(String.yourRecipes)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            .emptyView(
                if: items.isEmpty,
                label: Label(.noRecipes, sfSymbol: .forkKnife),
                description: {
                    Text(String.noRecipesDescription)
                },
                actions: {
                    WideButton(.idle(.addRecipe, sfSymbol: .plus)) {
                        isBrowserPresented = true
                    }
                }
            )
            .sheet(isPresented: $isBrowserPresented) {
                isBrowserPresented = false
            } content: {
                BrowserView()
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    HomeView()
}
