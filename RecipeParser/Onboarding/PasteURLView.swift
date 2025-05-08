//
//  PasteURLView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import SwiftUI

struct PasteURLView: View {
    @State var text: String = ""
    
    @State private var isValid = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parse Recipe via URL")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            
            CustomTextField(text: $text)
                .frame(maxWidth: .infinity)
                .textContentType(.URL)
            
            Button {
                // TODO: API call
            } label: {
                Text(String.parseRecipe)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
            .disabled(!isValid)
        }
        .padding(20)
    }
}

#Preview {
    PasteURLView()
}
