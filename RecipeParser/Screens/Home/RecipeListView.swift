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
    
    @Query(sort: \Recipe.createdOn, order: .reverse) private var items: [Recipe]
    @ScaledMetric private var spacing: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                ForEach(items, id: \.id) { recipe in
                    RecipeRow(recipe)
                        .navigate(to: RecipeView(recipe))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .listStyle(.plain)
        .refreshable {}
        .emptyView(
            Label(.noRecipes, sfSymbol: .forkKnife),
            if: isEmpty
        )
        .onAppear {
            isEmpty = items.isEmpty
        }
        .onChange(of: items) {
            isEmpty = items.isEmpty
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
    @Previewable @State var isEmpty: Bool = true
    
    RecipeListView(isEmpty: $isEmpty)
}
