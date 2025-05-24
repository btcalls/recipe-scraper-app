//
//  ShapeAndBorderModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

struct ShapeAndBorderModifier<S>: ViewModifier where S : Shape {
    var shape: S
    var lineWidth: CGFloat = 0
    var color: Color = .clear
    
    private var stroke: (width: CGFloat, color: Color)? {
        guard lineWidth > 0 && color != .clear else {
            return nil
        }
        
        return (lineWidth, color)
    }
    
    func body(content: Content) -> some View {
        switch stroke {
        case .none:
            content.clipShape(shape)
        
        case .some(let (lineWidth, color)):
            content
                .clipShape(shape)
                .overlay(shape.stroke(color, lineWidth: lineWidth))
        }
        
    }
}
