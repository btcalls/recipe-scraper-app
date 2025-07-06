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
    
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var recipeMetadata: RecipeMetadata?
    @State private var viewState = ViewState()
    
    init(url: URL) {
        sharedURL = url
    }
    
    var body: some View {
        NavigationStack {
            LoadableView(viewState: viewState) {
                VStack(alignment: .center, spacing: spacing) {
                    RecipeMetadataView(metadata: recipeMetadata)
                    
                    Spacer()
                    
                    Divider().asStandard()
                    
                    WideButton(.saveRecipe) {
                        Task {
                            await processRecipe()
                        }
                    }
                }
                .toolbar {
                    Button(String.cancel) {
                        close()
                    }
                }
                .navigationTitle(String.addRecipe)
                .padding()
                .task {
                    await parseSharedURL()
                }
            }
        }
    }
    
    /// Parse and extracts metadata for the current recipe URL.
    private func parseSharedURL() async {
        recipeMetadata = try? await ExtractRecipeMetadata(url: sharedURL)
            .parse()
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
                viewState.toast = .error(.app(.persistentDataLookupError))
            }
        } catch let e as CustomError {
            viewState.toast = .error(e)
        } catch let e {
            viewState.toast = .error(.error(e))
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
