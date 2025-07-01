//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

private struct SeeAllButton: View {
    @Binding var isEmpty: Bool
    
    var body: some View {
        Label(.seeAll, sfSymbol: .chevronRightCircle)
            .labelStyle(CustomLabelStyle(.titleIcon()))
            .navigate(to: RecipeListView(.full, isEmpty: $isEmpty))
            .buttonStyle(AppButtonStyle())
            .foregroundStyle(Color.accentColor)
    }
}

struct HomeView: View {
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var isBrowserPresented = false
    @State private var isEmpty: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: spacing) {
                    SeeAllButton(isEmpty: $isEmpty)
                        .remove(if: isEmpty)
                    
                    RecipeListView(.first(3), isEmpty: $isEmpty)
                    
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
            ) {
                WideButton(.addRecipe, icon: .plus) {
                    isBrowserPresented = true
                }
            }
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
