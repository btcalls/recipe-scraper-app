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
    @StateObject private var viewState = ViewState()
    
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
                    
                    Divider()
                        .frame(height: 1)
                        .background(.secondary.opacity(0.5))
                    
                    CustomButton(.saveRecipe) {
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
