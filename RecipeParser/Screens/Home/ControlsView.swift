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
    @State private var isSearching: Bool = false
    
    @ViewBuilder private func panelView() -> some View {
        HStack(spacing: spacing) {
            if isSearching {
                HStack(alignment: .center) {
                    TextField(String.searchRecipe, text: $query)
                        .focused($focusedField, equals: .search)
                        .scale(.padding(.leading), 10)
                    
                    IconButton(.xmarkCircle, kind: .muted) {
                        query = ""
                    }
                    .disabled(query.isEmpty)
                }
                .transition(.opacity)
            }
            
            IconButton(isSearching ? .chevronLeft : .search) {
                withAnimation {
                    isSearching.toggle()
                    
                    focusedField = isSearching ? .search : nil
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            panelView()
        }
        .buttonStyle(AppButtonStyle())
        .scale(.padding(.all), 10)
        .background(Color.appBackground.brightness(0.1))
        .clipTo(RoundedRectangle(cornerRadius: 27))
        .shadow()
    }
}

#Preview {
    @Previewable @StateObject var searchContext = SearchContext()
    
    ControlsView(query: $searchContext.query)
}
