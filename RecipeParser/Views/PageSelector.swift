//
//  PageSelector.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 30/12/2025.
//

import SwiftUI

struct PageSelector<SelectionValue>: View where SelectionValue : Hashable {
    @Binding var selection: SelectionValue
    var pages: [SelectionValue]
    
    private func color(for isSelected: Bool) -> Color {
        isSelected ? .accentColor : .appForeground.opacity(0.3)
    }
    
    private func value(for isSelected: Bool) -> CGFloat {
        isSelected ? 12 : 10
    }
    
    var body: some View {
        HStack(spacing: Layout.Spacing.medium) {
            ForEach(pages, id: \.self) { index in
                Circle()
                    .fill(color(for: index == selection))
                    .frame(width: value(for: index == selection),
                           height: value(for: index == selection))
                    .animation(.customInteractiveSpring, value: selection)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = index
                        }
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: Int = 0
    
    PageSelector(selection: $selection, pages: [0, 1])
}
