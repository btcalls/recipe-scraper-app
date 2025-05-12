//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct ParseRecipeView: View {
    @State var sharedURL: URL
    
    @State private var recipeMetadata: RecipeMetadata?
    
    init(url: URL) {
        sharedURL = url
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Recipe from \(Text(sharedURL.absoluteString).fontWeight(.medium)).")
                    .font(.subheadline)
                
                Divider()
                
                RecipeMetadataView(metadata: recipeMetadata)
                
                Spacer()
                
                Button {
                    // TODO: API client call
                    close()
                } label: {
                    Text(String.parseRecipe)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
            }
            .padding()
            .toolbar {
                Button(String.cancel) {
                    close()
                }
            }
            .navigationTitle(String.addNewRecipe)
            .task {
                await parseSharedURL()
            }
        }
    }
    
    private func close() {
        AppSettings.shared.isOnboardingComplete = true
        
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
    
    private func parseSharedURL() async {
        recipeMetadata = try? await ExtractRecipeMetadata(url: sharedURL)
            .parse()
    }
}

#Preview {
    ParseRecipeView(url: URL(string: "https://www.recipetineats.com/crispy-oven-baked-quesadillas/")!)
}
