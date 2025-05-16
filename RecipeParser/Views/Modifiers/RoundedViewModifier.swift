//
//  RoundedViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

struct RoundedViewModifier: ViewModifier {
    var cornerRadius: CornerRadius
    var lineWidth: CGFloat = 0
    var color: Color = .clear
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius.rawValue))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius.rawValue)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
