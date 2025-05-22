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
    private var items: [Recipe] = [.sample]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        Text(item.name)
                            .font(.title)
                        Text(item.detail)
                            .font(.caption)
                    } label: {
                        Text(item.name)
                        Text(item.detail)
                            .lineLimit(3)
                    }
                }
            }
            .refreshable {}
            .navigationTitle(String.yourRecipes)
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(String.noRecipes,
                                           systemImage: Symbol.forkKnife.rawValue,
                                           description: Text(String.noRecipesDescription))
                }
            }
        } detail: {
            // TODO:
        }
    }
}

#Preview {
    HomeView()
}
