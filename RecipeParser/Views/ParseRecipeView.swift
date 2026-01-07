//
//  ParseRecipeView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI
import SwiftData

struct ParseRecipeView: View {
    var sharedURL: URL
    
    private var client = APIClient<RecipeEndpoints>()
    
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    @State private var recipeMetadata: RecipeMetadata?
    @State private var viewState = ViewState()
    
    init(url: URL) {
        sharedURL = url
    }
    
    var body: some View {
        NavigationStack {
            LoadableView(viewState: viewState) {
                ScrollView {
                    VStack(alignment: .center, spacing: spacing) {
                        RecipeInfoView(metadata: recipeMetadata)
                            .redacted(as: .placeholder, if: recipeMetadata == nil)
                        
                        Spacer()
                    }
                }
                .scale(.padding(.horizontal), 20)
                .toolbar {
                    Button(role: .close) {
                        close()
                    }
                    .disabled(viewState.isProcessing)
                    
                    Button(String.saveRecipe, role: .confirm) {
                        Task {
                            await processRecipe()
                        }
                    }
                    .disabled(viewState.isProcessing)
                }
            }
            .task {
                await parseSharedURL()
            }
        }
    }
    
    /// Parse and extracts metadata for the current recipe URL.
    private func parseSharedURL() async {
        do {
            recipeMetadata = try await ExtractRecipeMetadata(url: sharedURL)
                .parse()
        } catch {
            viewState.toast = .failure(.error(error))
        }
    }
    
    /// Starts parsing recipe and saving to persistent storage.
    private func processRecipe() async {
        defer {
            viewState.isProcessing = false
        }
        
        // Start loading state
        viewState.isProcessing = true
        viewState.toast = .loading(.parsingRecipe)

        do {
            // Process request and save resulting model
            let container = ModelContainer.shared()
            let model: ModelDTO<Recipe> = try await client.request(
                .parseRecipe(sharedURL),
                storeTo: container
            )
            
            viewState.toast = nil
            
            // Check if model was successfully saved in storage
            let context = ModelContext(container)
            
            if context.hasModel(model) {
                close(hasCompleted: true)
            } else {
                viewState.toast = .failure(.app(.persistentDataLookupError))
            }
        } catch let e as CustomError {
            viewState.toast = .failure(e)
        } catch let e {
            viewState.toast = .failure(.error(e))
        }
    }
    
    /// Starts closing of this view and the Share view.
    /// - Parameter hasCompleted: Flag whether a successful parsing was completed.
    private func close(hasCompleted: Bool = false) {
        AppValues.shared.isOnboardingComplete = hasCompleted
        
        // Notify closing of Share view
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}

#Preview {
    ParseRecipeView(url: MockService.shared.recipeURL)
}
