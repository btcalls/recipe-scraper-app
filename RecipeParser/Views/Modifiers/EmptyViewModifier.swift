//
//  EmptyViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 25/5/2025.
//

import SwiftUI

struct EmptyViewModifier<Label, Actions>: ViewModifier where Label : View, Actions: View {
    @ViewBuilder var label: Label
    @ViewBuilder var actions: Actions
    
    var condition: Bool
    var description: String? = nil
    
    init(
        _ label: Label,
        if condition: Bool,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.label = label
        self.condition = condition
        self.description = description
        self.actions = actions()
    }
    
    func body(content: Content) -> some View {
        switch condition {
        case false:
            content
        
        case true:
            content
                .overlay {
                    ContentUnavailableView(label: {
                        label
                    }, description: {
                        if let description {
                            Text(description)
                        } else {
                            EmptyView()
                        }
                    }) { actions }
                }
        }
    }
}
