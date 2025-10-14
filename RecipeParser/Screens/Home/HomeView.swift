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
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var isBrowserPresented = false
    @State private var isEmpty: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: spacing) {
                    NavigationLink(destination: RecipeListView(isEmpty: $isEmpty)) {
                        Label(
                            String.seeAll,
                            systemImage: Symbol.chevronRightCircle.rawValue
                        )
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(.glass)
                    
                    RecipeListView(.first(3), isEmpty: $isEmpty)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.appBackground)
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                if !isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isBrowserPresented = true
                        } label: {
                            Symbol.plus.image
                        }
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
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(MockService.shared.modelContainer(withSample: true))
    }
}
