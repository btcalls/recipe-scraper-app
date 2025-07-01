//
//  RecipeListView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI
import SwiftData

private struct BaseListView: View {
    var items: [Recipe]
    
    @ScaledMetric private var spacing: CGFloat = 15
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(items, id: \.id) {
                RecipeRow($0)
                    .navigate(to: RecipeView($0))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct BaseView: View {
    var mode: RecipeListView.Mode = .full
    var items: [Recipe]
    
    var body: some View {
        ScrollView {
            switch mode {
            case .first(_:):
                BaseListView(items: items)
                    .navigationTitle("")
                
            case .full:
                BaseListView(items: items)
                    .navigationTitle(String.allRecipes)
                    .padding()
            }
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .listStyle(.plain)
    }
}

struct RecipeListView: View {
    var mode: Mode = .full
    
    @Binding var isEmpty: Bool
    
    /// Updated list of recipes based on search query and sorting selections.
    private var updatedResults: [Recipe] {
        let descriptor = Recipe.getSortDescriptor(for: sortItem.keyPath,
                                                  order: sortOrder.value)
        let sorted = items.sorted(using: descriptor)
        
        // Sort results
        if searchContext.debouncedQuery.isEmpty {
            return sorted
        }
        
        // Search results
        return sorted.filter {
            $0.name.contains(searchContext.debouncedQuery)
        }
    }
    
    @Query private var items: [Recipe]
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var sortItem: SortItem<Recipe> = .createdOn
    @State private var sortOrder: SortOrderItem = .latest
    @StateObject private var searchContext = SearchContext()
    
    var body: some View {
        switch mode {
        case .first(_:):
            BaseView(mode: mode, items: updatedResults)
                .onAppear {
                    isEmpty = items.isEmpty
                }
                .emptyView(
                    Label(.noRecipes, sfSymbol: .forkKnife),
                    if: isEmpty,
                    for: .generic
                )
        
        case .full:
            BaseView(mode: mode, items: updatedResults)
                .onChange(of: items) {
                    isEmpty = items.isEmpty
                }
                .emptyView(
                    Label(.noRecipes, sfSymbol: .forkKnife),
                    if: items.isEmpty || updatedResults.isEmpty,
                    for: items.isEmpty ? .generic : .search(searchContext.query)
                )
                .searchable(
                    text: $searchContext.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text(String.searchRecipe)
                )
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    BottomControlView {
                        SortControlView<Recipe>(
                            sortItem: $sortItem.animation(.snappy),
                            sortOrder: $sortOrder.animation(.snappy)
                        )
                    }
                    .buttonStyle(AppButtonStyle())
                    .scale(.padding(.trailing), 10)
                }
        }
    }
}

extension RecipeListView {
    init(_ mode: Mode = .full, isEmpty: Binding<Bool>) {
        self.mode = mode
        self._isEmpty = isEmpty
        
        // Setup initial query for items
        var descriptor = FetchDescriptor<Recipe>(
            sortBy: [Recipe.getSortDescriptor(for: self.sortItem.keyPath,
                                              order: self.sortOrder.value)]
        )
        
        switch mode {
        case .first(let limit):
            descriptor.fetchLimit = limit
            
            self._items = Query(descriptor)
        
        case .full:
            self._items = Query(descriptor)
        }
    }
}

extension RecipeListView {
    enum Mode {
        case first(Int)
        case full
    }
}

#Preview {
    @Previewable @State var isEmpty: Bool = false
    
    RecipeListView(isEmpty: $isEmpty)
        .modelContainer(MockService.shared.modelContainer(withSample: !isEmpty))
}
