//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ScaledMetric private var height: CGFloat = 275
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    @State private var isBrowserPresented = false
    @State private var isEmpty: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: spacing) {
                    Label(.seeAll, sfSymbol: .chevronRightCircle)
                        .padding()
                        .asLink(value: String.seeAll)
                        .remove(if: isEmpty)
                    
                    RecipeListView(view: .first(3), isEmpty: $isEmpty)
                    
                    Spacer()
                }
                .padding()
                .navigationDestination(for: String.self) { value in
                    RecipeListView(isEmpty: $isEmpty)
                }
            }
            .background(Color.appBackground)
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                if !isEmpty {
                    Button(.plus, role: .confirm) {
                        isBrowserPresented = true
                    }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(MockService.shared.modelContainer(withSample: true))
    }
}
