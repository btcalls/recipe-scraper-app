//
//  Models.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import UIKit

struct RecipeMetadata {
    var title: String
    var description: String
    var hostName: String
    var image: UIImage? = nil
    var icon: UIImage? = nil
}

struct SortItem<Model>: Equatable, Hashable {
    let title: String
    let keyPath: PartialKeyPath<Model>
    
    init<Value>(_ keyPath: KeyPath<Model, Value>, as title: String) where Value : Comparable {
        self.title = title
        self.keyPath = keyPath
    }
    
    static func ==(lhs: SortItem<Model>, rhs: SortItem<Model>) -> Bool {
        return lhs.title == rhs.title && lhs.keyPath == rhs.keyPath
    }
}

extension SortItem where Model == Recipe {
    static var createdOn = Self(\.createdOn, as: "Save Date")
    static var name = Self(\.name, as: "Name")
}

struct SortOrderItem: Equatable {
    let title: String
    let value: SortOrder
    
    static func ==(lhs: SortOrderItem, rhs: SortOrderItem) -> Bool {
        return lhs.title == rhs.title && lhs.value == rhs.value
    }
}

extension SortOrderItem {
    static let az: Self = .init(title: "A-Z", value: .forward)
    static let za: Self = .init(title: "Z-A", value: .reverse)
    static let latest: Self = .init(title: "Latest", value: .reverse)
    static let oldest: Self = .init(title: "Oldest", value: .forward)
}
