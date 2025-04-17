//
//  Item.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
