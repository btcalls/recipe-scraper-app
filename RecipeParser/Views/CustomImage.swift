//
//  CustomImage.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

// TODO: Handle async loading of image

struct CustomImage: View {
    var resourceName: String = "Placeholder"
    
    var body: some View {
        Image(resourceName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    CustomImage()
        .frame(width: 80, height: 80)
        .clipTo(shape: Circle(),
                lineWidth: 1,
                color: .primary)
        
}
