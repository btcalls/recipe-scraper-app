//
//  RecipeMetadataView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI

struct RecipeMetadataView: View {
    private let size: CGFloat = 110
    
    var metadata: RecipeMetadata?
    
    private var recipeImage: Image {
        guard let metadata, let image = metadata.image else {
            return Image("Placeholder")
        }
        
        return Image(uiImage: image)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            recipeImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .rounded(cornerRadius: .regular)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(metadata?.title ?? .placeholder(length: 15))
                    .font(.title2)
                Text(metadata?.description ?? .placeholder(length: 60))
                    .lineLimit(2)
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
