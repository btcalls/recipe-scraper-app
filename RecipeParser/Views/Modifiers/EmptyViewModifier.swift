//
//  EmptyViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 25/5/2025.
//

import SwiftUI

struct EmptyViewModifier<Label, Description, Actions>: ViewModifier where Label : View, Description: View, Actions: View {
    var condition: Bool
    
    @ViewBuilder var label: Label
    @ViewBuilder var actions: Actions
    @ViewBuilder var description: Description
    
    func body(content: Content) -> some View {
        switch condition {
        case false:
            content
        
        case true:
            content
                .overlay(alignment: .center) {
                    ContentUnavailableView(label: {
                        label
                    }, description: {
                        description
                    }) { actions }
                }
        }
    }
}

extension EmptyViewModifier {
    init(
        if condition: Bool,
        label: Label,
        @ViewBuilder description: () -> Description = EmptyView.init,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) {
        self.condition = condition
        self.label = label
        self.description = description()
        self.actions = actions()
    }
}

extension EmptyViewModifier where Description == Text {
    init(
        if condition: Bool,
        label: Label,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) {
        self.condition = condition
        self.label = label
        self.description = { Text(description ?? "") }()
        self.actions = actions()
    }
}
