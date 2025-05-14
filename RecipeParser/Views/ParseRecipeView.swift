//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct ParseRecipeView: View {
    @State private var recipeMetadata: RecipeMetadata?
    @ObservedObject private var viewModel = ParseRecipeViewModel()
    
    var sharedURL: URL
    
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
                    Task {
                        await processRecipe()
                    }
                } label: {
                    Text(viewModel.isFetching ? String.fetching : String.parseRecipe)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
                .disabled(viewModel.isFetching)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
            }
            .padding()
            .toolbar {
                Button(String.cancel) {
                    close()
                }
                .disabled(viewModel.isFetching)
            }
            .navigationTitle(String.addNewRecipe)
            .task {
                await parseSharedURL()
            }
        }
    }
    
    private func parseSharedURL() async {
        recipeMetadata = try? await ExtractRecipeMetadata(url: sharedURL)
            .parse()
    }
    
    private func processRecipe() async {
        await viewModel.process(sharedURL)
        
        if viewModel.error == nil {
            close()
        }
    }
    
    private func close() {
        AppSettings.shared.isOnboardingComplete = true
        
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}

#Preview {
    ParseRecipeView(url: URL(string: "https://www.recipetineats.com/crispy-oven-baked-quesadillas/")!)
}
