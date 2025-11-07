//
//  SortControlView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/6/2025.
//

import SwiftUI

private struct SelectedLabel: View {
    var text: String
    var isSelected: Bool
    
    var body: some View {
        if isSelected {
            Label(text, sfSymbol: .checkmark)
        } else {
            Text(text)
        }
    }
}

struct SortControlView<Model: SortableModel>: View {
    var sortItems: [SortItem<Model>]
    
    @Binding var sortItem: SortItem<Model>
    @Binding var sortOrderItem: SortOrderItem
    
    @State private var activeSortOrders: [SortOrderItem] = []
    
    var body: some View {
        Menu {
            ForEach(sortItems, id: \.title) { item in
                Button {
                    sortItem = item
                } label: {
                    SelectedLabel(
                        text: item.title,
                        isSelected: item == sortItem
                    )
                }
            }
            
            Divider()
            
            ForEach(activeSortOrders, id: \.title) { item in
                Button {
                    sortOrderItem = item
                } label: {
                    SelectedLabel(
                        text: item.title,
                        isSelected: item == sortOrderItem
                    )
                }
            }
        } label: {
            Symbol.sort.image
        }
        .menuOrder(.fixed)
        .onChange(of: sortItem) {
            activeSortOrders = Model.sortItems[sortItem] ?? [.latest]
            sortOrderItem = activeSortOrders.first ?? .latest
        }
    }
}

extension SortControlView {
    init(
        sortItem item: Binding<SortItem<Model>>,
        sortOrder order: Binding<SortOrderItem>
    ) {
        self._sortItem = item
        self._sortOrderItem = order
        self._activeSortOrders = State(
            initialValue: Model.sortItems[item.wrappedValue] ?? [.latest]
        )
        
        self.sortItems = [SortItem<Model>](Model.sortItems.keys)
    }
}

#Preview {
    @Previewable @State var isEmpty: Bool = false
    
    NavigationStack {
        RecipeListView(isEmpty: $isEmpty)
            .modelContainer(MockService.shared.modelContainer(withSample: !isEmpty))
    }
}
