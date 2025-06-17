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
    
    private var searchResults: [Recipe] {
        if searchContext.debouncedQuery.isEmpty {
            return items
        }
        
        return items.filter {
            $0.name.contains(searchContext.debouncedQuery)
        }
    }
    
    @Query private var items: [Recipe]
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var emptyViewType = EmptyViewType.generic
    @StateObject private var searchContext = SearchContext()
    
    @ViewBuilder private func listView() -> some View {
        VStack(spacing: spacing) {
            ForEach(searchResults, id: \.id) { recipe in
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
                
            case .full:
                listView()
                    .padding()
            }
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .listStyle(.plain)
        .refreshable {}
        .navigationTitle("")
        .emptyView(
            Label(.noRecipes, sfSymbol: .forkKnife),
            if: isEmpty || searchResults.isEmpty,
            for: emptyViewType
        )
        .onAppear {
            isEmpty = items.isEmpty
        }
        .onChange(of: items) {
            isEmpty = items.isEmpty
        }
        .onChange(of: searchResults) {
            emptyViewType = searchResults.isEmpty ? .search : .generic
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
        }
    }
}

extension RecipeListView {
    init(_ mode: Mode = .full, isEmpty: Binding<Bool>) {
        self.mode = mode
        self._isEmpty = isEmpty
        
        // Configure query
        var descriptor = FetchDescriptor<Recipe>(
            sortBy: [SortDescriptor(\.createdOn, order: .reverse)]
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
        .modelContainer(.mock(withSample: true))
}
