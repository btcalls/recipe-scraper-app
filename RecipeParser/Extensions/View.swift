//
//  View.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 5/5/2025.
//

import SwiftUI

extension View {
    public func rounded(cornerRadius: CGFloat,
                        lineWidth: CGFloat,
                        color: Color) -> some View {
        modifier(RoundedView(cornerRadius: cornerRadius,
                             lineWidth: lineWidth,
                             color: color))
    }
}
