//
//  ScaledModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

struct ScaledModifier: ViewModifier {
    var scaleType: Kind
    
    @ScaledMetric var value: CGFloat
    
    init(scaleType: Kind, value: CGFloat, relativeTo: Font.TextStyle = .body) {
        self.scaleType = scaleType
        self._value = ScaledMetric(wrappedValue: value, relativeTo: relativeTo)
    }
    
    func body(content: Content) -> some View {
        switch scaleType {
        case .padding(let edge):
            content.padding(edge, value)
            
        case .height(let isMinimum):
            if isMinimum {
                content.frame(minHeight: value)
            } else {
                content.frame(height: value)
            }
            
        case .width(let isMinimum):
            if isMinimum {
                content.frame(minWidth: value)
            } else {
                content.frame(width: value)
            }
            
        case .square(let isMinimum):
            if isMinimum {
                content.frame(minWidth: value, minHeight: value)
            } else {
                content.frame(width: value, height: value)
            }
        }
    }
}

extension ScaledModifier {
    enum Kind {
        case padding(Edge.Set)
        case height(isMinimum: Bool = false)
        case width(isMinimum: Bool = false)
        case square(isMinimum: Bool = false)
    }
}
