//
//  Animation+Extensions.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 9/7/2025.
//

import SwiftUI

extension Animation {
    static var customBouncy: Animation = .bouncy(duration: 0.25, extraBounce: 0.15)
    static var customEaseInOut: Animation = .easeInOut(duration: 0.15)
    static var customInteractiveSpring: Animation = .interactiveSpring(response: 0.5,
                                                                       dampingFraction: 0.8,
                                                                       blendDuration: 0)
}
