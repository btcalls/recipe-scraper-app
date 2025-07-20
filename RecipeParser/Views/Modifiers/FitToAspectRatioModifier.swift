//
//  FitToAspectRatioModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 20/7/2025.
//

import SwiftUI

/// Based on: https://medium.com/expedia-group-tech/resizing-images-in-swiftui-e65ced420b81
struct FitToAspectRatio: ViewModifier {
    private let aspectRatio: CGFloat
    
    public init(_ aspectRatio: CGFloat) {
        self.aspectRatio = aspectRatio
    }
    
    public init(_ aspectRatio: AspectRatio) {
        self.aspectRatio = aspectRatio.rawValue
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.clear))
                .aspectRatio(aspectRatio, contentMode: .fit)
            
            content
                .scaledToFill()
                .layoutPriority(-1)
        }
        .clipped()
    }
}
