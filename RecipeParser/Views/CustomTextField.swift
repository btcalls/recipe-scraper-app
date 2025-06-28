//
//  CustomTextField.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 24/6/2025.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @FocusState var focused: Bool
    
    var placeholder: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .focused($focused)
            
            IconButton(.xmarkCircle, kind: .muted) {
                text = ""
            }
            .disabled(text.isEmpty)
        }
    }
}

extension CustomTextField {
    enum Key {
        case search
    }
}
