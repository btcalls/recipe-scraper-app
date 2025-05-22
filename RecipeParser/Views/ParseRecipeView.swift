//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI
import SwiftData

struct ParseRecipeView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @Environment(\.modelContext) private var context
    @ObservedObject private var viewState = ViewState()
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
            LoadableView(viewState: viewState) {
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
        defer {
            viewState.isProcessing = false
        }
        
        viewState.isProcessing = true
        viewState.toast = .loading(.parsingRecipe)

        do {
            let model: Model<Recipe> = try await APIClient.shared
                .send(HomeEndpoints.parseRecipe(sharedURL), storeTo: context)
            
            viewState.toast = nil
            
            if let _ = try context.getModel(model) {
                close()
            }
        } catch(let e) {
            if let customError = e as? CustomError {
                viewState.toast = .error(customError)
            } else {
                viewState.toast = .error(CustomError.error(e))
            }
        }
    }
    
    private func close() {
        appSettings.isOnboardingComplete = true
        
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}

#Preview {
    ParseRecipeView(url: URL(string: "https://www.recipetineats.com/crispy-oven-baked-quesadillas/")!)
}
