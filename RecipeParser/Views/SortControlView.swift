//
//  SortControlView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 26/6/2025.
//

import SwiftUI

struct SortControlView<Model: SortableModel>: View {
    var sortItems: [SortItem<Model>]
    
    @Binding var sortItem: SortItem<Model>
    @Binding var sortOrderItem: SortOrderItem
    
    @State private var activeSortOrders: [SortOrderItem] = []
    @State private var isEnabled = false
    
    @ViewBuilder private func contentView() -> some View {
        HStack(alignment: .center) {
            Text(String.sortBy)
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
            
            Spacer()
            
            Group {
                Menu(sortItem.title) {
                    ForEach(sortItems, id: \.title) { item in
                        Button {
                            sortItem = item
                        } label: {
                            if (item == sortItem) {
                                Label(item.title, sfSymbol: .checkmark)
                            } else {
                                Text(item.title)
                            }
                        }
                    }
                }
                
                Menu(sortOrderItem.title) {
                    ForEach(activeSortOrders, id: \.title) { item in
                        Button {
                            sortOrderItem = item
                        } label: {
                            if (item == sortOrderItem) {
                                Label(item.title, sfSymbol: .checkmark)
                            } else {
                                Text(item.title)
                            }
                        }
                    }
                }
                .remove(if: activeSortOrders.isEmpty)
            }
            .disableAnimation()
            .menuStyle(AppMenuStyle())
            .menuOrder(.fixed)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if isEnabled {
                contentView()
            }
            
            IconButton(isEnabled ? .chevronLeft : .sort) {
                withAnimation {
                    isEnabled.toggle()
                }
            }
        }
        .font(.subheadline)
        .transition(.opacity)
        .onChange(of: sortItem) {
            activeSortOrders = Model.sortItems[sortItem] ?? []
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
        
        self.sortItems = [SortItem<Model>](Model.sortItems.keys)
        
        self._activeSortOrders = State(
            initialValue: Model.sortItems[item.wrappedValue] ?? []
        )
    }
}
