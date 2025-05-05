//
//  PasteURLView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import SwiftUI

struct PasteURLView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parse Recipe via URL")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            CustomTextField(text: $text)
                .frame(maxWidth: .infinity)
                .textContentType(.URL)
            Button() {
                // TODO: Submit to API
            } label: {
                Text("Parse")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2.5)
            }
                .buttonStyle(.borderedProminent)
        }
        .padding(20)
    }
}

#Preview {
    PasteURLView()
}
