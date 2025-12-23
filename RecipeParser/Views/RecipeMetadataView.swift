//
//  RecipeMetadataView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct RecipeMetadataView: View {
    var metadata: RecipeMetadata?
    
    @ScaledMetric private var size: CGFloat = 150
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    @ScaledMetric private var bodySpacing = Layout.Spacing.medium
    
    private var recipeImage: CustomImage {
        guard let metadata, let image = metadata.image else {
            return .init(kind: .resource("Placeholder"))
        }
        
        return .init(kind: .uiImage(image))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            recipeImage
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
                .clipTo(RoundedRectangle(cornerRadius: .medium))
            
            VStack(alignment: .center, spacing: bodySpacing) {
                Text(metadata?.title ?? .placeholder(length: 30))
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

                Text(metadata?.description ?? .placeholder(length: 80))
                    .lineLimit(3)
                    .truncationMode(.tail)
            }
            .font(.subheadline)
            .multilineTextAlignment(.leading)
        }
        .redacted(as: .placeholder, if: metadata == nil)
    }
}

#Preview {
    RecipeMetadataView()
}
