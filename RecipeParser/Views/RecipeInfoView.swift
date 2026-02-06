//
//  RecipeMetadataView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

private struct DetailsView: View {
    let recipe: Recipe
    
    @ScaledMetric private var spacing = Layout.Scaled.interItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(recipe.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(recipe.detail)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .scale(.padding(.vertical), 10)
        }
    }
}

struct RecipeInfoView: View {
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    @ScaledMetric private var bodySpacing = Layout.Scaled.interItem
    
    private let name: String
    private let description: String
    private let recipeImage: CustomImage
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            recipeImage
                .scale(.height(), 300)
                .fitToAspectRatio(.photo16x9)
                .clipTo(RoundedRectangle(cornerRadius: .large))
                .padding(.vertical, 10)
                .shadow()
            
            VStack(alignment: .center, spacing: bodySpacing) {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scale(.padding(.vertical), 10)
            }
            .font(.subheadline)
            .multilineTextAlignment(.leading)
        }
    }
}

extension RecipeInfoView {
    init(metadata: RecipeMetadata? = nil) {
        if let metadata, let image = metadata.image {
            self.recipeImage = .init(kind: .uiImage(image))
        } else {
            self.recipeImage = .init(kind: .resource("Placeholder"))
        }
        
        self.name = metadata?.title ?? .placeholder(length: 30)
        self.description = metadata?.description ?? .placeholder(length: 80)
    }
    
    init(recipe: Recipe) {
        self.recipeImage = .init(kind: .url(recipe.imageURL, toCache: true))
        self.name = recipe.name
        self.description = recipe.detail
    }
}

#Preview {
    RecipeInfoView(recipe: MockService.shared.getRecipe())
//        .redacted(as: .placeholder, if: true)
}
