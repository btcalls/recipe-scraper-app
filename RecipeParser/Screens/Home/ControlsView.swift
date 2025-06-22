//
//  ControlsView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 19/6/2025.
//

import SwiftUI

struct ControlsView: View {
    private enum FocusedField {
        case search
    }
    
    @Binding var query: String
    
    @FocusState private var focusedField: FocusedField?
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var activeControl: ActiveControl?
    
    @ViewBuilder private func activeControlView() -> some View {
        VStack(spacing: spacing) {
            switch activeControl {
            case .search:
                HStack(alignment: .center) {
                    TextField(String.searchRecipe, text: $query)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .search)
                        .scale(.padding(.leading), 10)
                    
                    IconButton(.xmarkCircle, kind: .muted) {
                        query = ""
                    }
                    .disabled(query.isEmpty)
                }
                .transition(.opacity)
                
            case .sort:
                HStack(alignment: .center) {
                    Text("Sort By:")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                    
                    Menu("Saved Date") {
                        Button("Name") {}
                        Button("Saved Date") {}
                    }
                    .frame(maxWidth: .infinity)
                    .clipTo(.capsule)
                    
                    Menu("Latest") {
                        Button("Oldest") {}
                        Button("Latest") {}
                    }
                }
                .scale(.padding(.horizontal), 10)
                .transition(.opacity)
                
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder private func controlView() -> some View {
        IconButton(activeControl == .sort ? .chevronLeft : .sort) {
            withAnimation {
                activeControl.toggle(between: .sort)
            }
        }.remove(if: activeControl == .search)
        
        IconButton(activeControl == .search ? .chevronLeft : .search) {
            withAnimation {
                activeControl.toggle(between: .search)
                
                focusedField = activeControl == .search ? .search : nil
            }
        }
        .remove(if: activeControl == .sort)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            activeControlView()
            
            controlView()
        }
        .buttonStyle(AppButtonStyle())
        .scale(.padding(.all), 10)
        .background(Color.appBackground.brightness(0.1))
        .clipTo(RoundedRectangle(cornerRadius: 27))
        .shadow()
    }
}

extension ControlsView {
    enum ActiveControl: String {
        case search
        case sort
    }
}

#Preview {
    @Previewable @StateObject var searchContext = SearchContext()
    
    ControlsView(query: $searchContext.query)
}
