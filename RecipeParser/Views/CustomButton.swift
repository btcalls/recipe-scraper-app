//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

struct CustomButton: View {
    var state: State
    var role: ButtonRole? = .none
    var action: @MainActor () -> Void
    
    @ViewBuilder private var imageAndLabelView: some View {
        switch state {
        case .idle(let title, let sfSymbol):
            if let sfSymbol {
                sfSymbol.image
            }
            
            Text(title)
        
        case .loading(let title):
            ProgressView()
            
            Text(title)
        }
    }
    
    var body: some View {
        Button(role: role, action: action) {
            HStack(alignment: .center, spacing: 5) {
                imageAndLabelView
                    .bold()
                    .padding(.vertical, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: CornerRadius.sm.rawValue))
    }
}

extension CustomButton {
    enum State {
        case idle(String, Symbol? = nil)
        case loading(String = .processing)
    }
    
    internal init(
        _ state: State,
        action: @escaping @MainActor () -> Void
    ) {
        self.state = state
        self.action = action
    }
    
    internal init(
        _ title: String,
        action: @escaping @MainActor () -> Void
    ) {
        self.state = .idle(title)
        self.action = action
    }
}

#Preview {
    CustomButton(.idle("Text")) {}
    CustomButton(state: .idle("Delete"), role: .destructive) {}
}
