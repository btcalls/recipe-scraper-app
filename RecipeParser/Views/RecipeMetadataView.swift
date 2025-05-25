//
//  RecipeMetadataView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct RecipeMetadataView: View {
    private let size: CGFloat = 150
    
    var metadata: RecipeMetadata?
    
    private func recipeImage() -> Image {
        guard let metadata, let image = metadata.image else {
            return Image("Placeholder")
        }
        
        return Image(uiImage: image)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            recipeImage()
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
                .rounded(cornerRadius: .regular)
            
            VStack(alignment: .center, spacing: 10) {
                Text(metadata?.title ?? .placeholder(length: 30))
                    .font(.title2)
                    .fontWeight(.medium)

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
