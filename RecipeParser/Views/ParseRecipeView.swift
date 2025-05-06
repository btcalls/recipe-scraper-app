//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct ParseRecipeView: View {
    @State var sharedURL: URL
    
    init(url: URL) {
        sharedURL = url
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Recipe from \(sharedURL.absoluteString)")
                    .font(.subheadline)
                Button {
                    self.close()
                } label: {
                    Text("Parse Recipe")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
            }
            .padding()
            .toolbar {
                Button("Cancel") {
                    self.close()
                }
            }
            .navigationTitle("Add new Recipe")
        }
    }
    
    func saveLink(sharedLink: String) async {
        // do something
    }
    
    func close() {
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}
