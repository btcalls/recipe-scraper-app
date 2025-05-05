//
//  PasteURLView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 4/5/2025.
//

import SwiftUI

struct PasteURLView: View {
    var body: some View {
        Text("Recipe URL")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .font(.title)
        TextField("Paste URL here", text: .constant(""))
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(.gray)
            .padding(.horizontal, 20)
    }
}

#Preview {
    PasteURLView()
}
