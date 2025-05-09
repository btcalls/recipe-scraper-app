//
//  HomeModels.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import UIKit

struct Test: Codable {
    let id: Int
    let title: String
    let body: String
}

struct RecipeMetadata {
    var title: String
    var description: String
    var hostName: String
    var image: UIImage? = nil
    var icon: UIImage? = nil
}
