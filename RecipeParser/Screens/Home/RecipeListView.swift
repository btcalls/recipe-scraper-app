//
//  RecipeListView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 3/6/2025.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    var mode: Mode = .full
    
    @Binding var isEmpty: Bool
    
    private var updatedResults: [Recipe] {
        let descriptor = Recipe.getSortDescriptor(for: sortItem.keyPath,
                                                  order: sortOrder.value)
        let sorted = items.sorted(using: descriptor)
        
        if searchContext.debouncedQuery.isEmpty {
            return sorted
        }
        
        return sorted.filter {
            $0.name.contains(searchContext.debouncedQuery)
        }
    }
    
    @Query private var items: [Recipe]
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var sortItem: SortItem<Recipe> = .createdOn
    @State private var sortOrder: SortOrderItem = .latest
    @StateObject private var searchContext = SearchContext()
    
    @ViewBuilder private func listView() -> some View {
        VStack(spacing: spacing) {
            ForEach(updatedResults, id: \.id) { recipe in
                RecipeRow(recipe)
                    .navigate(to: RecipeView(recipe))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func baseView() -> some View {
        ScrollView {
            switch mode {
            case .first(_:):
                listView()
                    .navigationTitle("")
                
            case .full:
                listView()
                    .navigationTitle(String.allRecipes)
                    .padding()
            }
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .listStyle(.plain)
        .emptyView(
            Label(.noRecipes, sfSymbol: .forkKnife),
            if: isEmpty || updatedResults.isEmpty,
            for: updatedResults.isEmpty ? .search(searchContext.query) : .generic
        )
        .onAppear {
            isEmpty = items.isEmpty
        }
        .onChange(of: items) {
            isEmpty = items.isEmpty
        }
    }
    
    var body: some View {
        switch mode {
        case .first(_:):
            baseView()
        
        case .full:
            baseView()
                .searchable(
                    text: $searchContext.query,
                    placement: .navigationBarDrawer,
                    prompt: Text(String.searchRecipe)
                )
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    HStack {
                        SortControlView<Recipe>(
                            sortItem: $sortItem.animation(.snappy),
                            sortOrder: $sortOrder.animation(.snappy)
                        )
                    }
                    .buttonStyle(AppButtonStyle())
                    .scale(.padding(.all), 10)
                    .background(Color.appBackground)
                    .clipTo(RoundedRectangle(cornerRadius: 27))
                    .shadow()
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
