//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var isBrowserPresented = false
    @State private var isEmpty: Bool = false
    
    private func seeAllButton() -> some View {
        NavigationLink {
            RecipeListView(.full, isEmpty: $isEmpty)
        } label: {
            Label(.seeAll, sfSymbol: .chevronRight)
                .labelStyle(CustomLabelStyle(.titleIcon()))
        }
        .buttonStyle(PressableStyle())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: spacing) {
                    if !isEmpty {
                        seeAllButton()
                    }
                    
                    RecipeListView(.first(1), isEmpty: $isEmpty)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.appBackground)
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isBrowserPresented = true
                    } label: {
                        Symbol.plus.image
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text(String.yourRecipes)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            .emptyView(
                if: isEmpty,
                label: Label(.noRecipes, sfSymbol: .forkKnife),
                description: {
                    Text(String.noRecipesDescription)
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
