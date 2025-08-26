//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

private struct SeeAllButton: View {
    var body: some View {
        Label(.seeAll, sfSymbol: .chevronRightCircle)
            .labelStyle(CustomLabelStyle(.titleIcon()))
            .buttonStyle(CustomButtonStyle())
            .foregroundStyle(Color.accentColor)
    }
}

struct HomeView: View {
    @ScaledMetric private var height: CGFloat = 275
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var isBrowserPresented = false
    @State private var isEmpty: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: spacing) {
                    SeeAllButton()
                        .navigate(to: RecipeListView(isEmpty: $isEmpty))
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
                if !isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isBrowserPresented = true
                        } label: {
                            Symbol.plus.image
                                .bold()
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
        .modelContainer(MockService.shared.modelContainer(withSample: true))
}
