//
//  EmptyViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 25/5/2025.
//

import SwiftUI

struct EmptyViewModifier<Label, Description, Actions>: ViewModifier where Label : View, Description : View, Actions : View {
    var condition: Bool
    var type: EmptyViewType
    
    @ViewBuilder let label: Label
    @ViewBuilder var actions: Actions
    @ViewBuilder var description: Description
    
    func body(content: Content) -> some View {
        switch condition {
        case false:
            content
        
        case true:
            content
                .overlay(alignment: .center) {
                    switch type {
                    case .generic:
                        ContentUnavailableView(label: {
                            label
                        }, description: {
                            description
                        }) { actions }
                        
                    case .search(let text):
                        if let text {
                            ContentUnavailableView.search(text: text)
                        } else {
                            ContentUnavailableView.search
                        }
                    }
                }
        }
    }
}

extension EmptyViewModifier {
    init(
        for type: EmptyViewType = .generic,
        if condition: Bool,
        label: Label,
        @ViewBuilder description: () -> Description = EmptyView.init,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) {
        self.type = type
        self.condition = condition
        self.label = label
        self.description = description()
        self.actions = actions()
    }
}

extension EmptyViewModifier where Description == Text {
    init(
        for type: EmptyViewType = .generic,
        if condition: Bool,
        label: Label,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions = EmptyView.init
    ) {
        self.type = type
        self.condition = condition
        self.label = label
        self.description = { Text(description ?? "") }()
        self.actions = actions()
    }
}
