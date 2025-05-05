//
//  RoundedView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

struct RoundedView: ViewModifier {
    var cornerRadius: CGFloat = 0
    var lineWidth: CGFloat = 0
    var color: Color = .clear
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
