//
//  ContentView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel = HomeViewModel()
    @Query private var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(viewModel.data, id: \.id) { item in
                    NavigationLink {
                        Text(item.name)
                            .font(.title)
                        Text(item.description)
                            .font(.caption)
                    } label: {
                        Text(item.name)
                        Text(item.description)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .task {
            do {
                try await viewModel.fetchData()
            } catch {
                // TODO: Handle error
                Debugger.print(error)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
