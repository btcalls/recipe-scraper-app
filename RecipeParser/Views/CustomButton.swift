//
//  CustomButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import SwiftUI

struct CustomButton<Label>: View where Label : View {
    var action: @MainActor () -> Void
    var label: () -> Label
    
    var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
        }
    }
}

extension CustomButton where Label == Text {
    internal init(
        _ label: any StringProtocol,
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.label = {
            Text(label)
        }
    }
}
