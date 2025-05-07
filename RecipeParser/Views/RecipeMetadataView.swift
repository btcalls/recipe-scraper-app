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
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                getImage()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.largeTitle) // NOTE: For placeholder
                    .scaledToFill()
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
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
        .redacted(if: metadata == nil)
    }
    
    private func getImage() -> some View {
        guard let metadata, let image = metadata.image else {
            return Symbol.forkKnife.image
        }
        
        return Image(uiImage: image)
    }
}

#Preview {
    RecipeMetadataView()
}
