//
//  HiddenViewModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

import SwiftUI

struct HiddenViewModifier: ViewModifier {
    var condition: Bool
    var remove: Bool
    
    func body(content: Content) -> some View {
        switch condition {
        case false:
            content
            
        case true:
            if remove {
                EmptyView()
            } else {
                content.hidden()
            }
        }
    }
}
