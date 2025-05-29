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
                .navigationTitle(String.addNewRecipe)
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
        
        viewState.isProcessing = true
        viewState.toast = .loading(.parsingRecipe)

        do {
            let client = APIClient<RecipeEndpoints>()
            let model: Model<Recipe> = try await client
                .send(.parseRecipe(sharedURL), storeTo: context)
            
            viewState.toast = nil
            
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
        
        NotificationCenter.default.post(name: .closeShareView, object: nil)
    }
}

#Preview {
    ParseRecipeView(url: URL(string: .sampleRecipeURL)!)
}
