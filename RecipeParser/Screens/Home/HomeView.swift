//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
//    @Query(sort: \Recipe.createdOn, order: .reverse) private var items: [Recipe]
    private var items: [Recipe] = [.sample]
    
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var isBrowserPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing) {
                    RecipeListView()
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.appBackground)
            .scrollBounceBehavior(.basedOnSize)
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
