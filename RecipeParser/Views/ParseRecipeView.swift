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
    @State private var recipeMetadata: RecipeMetadata?
    @State private var viewState = ViewState()
    
    @ScaledMetric private var spacing: CGFloat = 20
    
    var sharedURL: URL
    
    private var client = APIClient<RecipeEndpoints>()
    
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
    
    private func parseSharedURL() async {
        recipeMetadata = try? await ExtractRecipeMetadata(url: sharedURL)
            .parse()
    }
    
    private func processRecipe() async {
        defer {
            viewState.isProcessing = false
        }
        
        // Start loading state
        viewState.isProcessing = true
        viewState.toast = .loading(.parsingRecipe)

        do {
            // Process request and save resulting model
            let model: ModelDTO<Recipe> = try await client.request(
                .parseRecipe(sharedURL),
                storeTo: .shared()
            )
            
            viewState.toast = nil
            
            // Check if model was successfully saved in storage
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
    
    private func close(hasCompleted: Bool = false) {
        AppValues.shared.isOnboardingComplete = hasCompleted
        
        // Notify closing of Share view
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}

#Preview {
    ParseRecipeView(url: MockService.shared.recipeURL)
}
