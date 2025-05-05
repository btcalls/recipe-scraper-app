//
//  CustomTextField.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        HStack {
            Image(systemName: "document.on.clipboard")
            TextField("Paste URL", text: $text)
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .font(.body)
        .foregroundColor(.primary)
        .rounded(cornerRadius: cornerRadius, lineWidth: 2, color: .primary)
    }
}
