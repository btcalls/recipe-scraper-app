//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI
import SwiftData

struct ParseRecipeView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var viewModel = ParseRecipeViewModel()
    @State private var recipeMetadata: RecipeMetadata?
    
    var sharedURL: URL
    
    init(url: URL) {
        sharedURL = url
    }
    
    private var urlText: Text {
        Text(sharedURL.absoluteString)
            .fontWeight(.medium)
            .foregroundStyle(.blue)
    }
    
    var body: some View {
        NavigationStack {
            LoadableView(viewModel: viewModel) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Recipe from \(urlText).")
                        .font(.subheadline)
                    
                    Divider()
                        .frame(height: 1)
                        .background(.secondary.opacity(0.5))
                    
                    RecipeMetadataView(metadata: recipeMetadata)
                    
                    Spacer()
                    
                    CustomButton(.idle(.saveRecipe)) {
                        Task {
                            await processRecipe()
                        }
                    }
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
