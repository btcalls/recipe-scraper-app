//
//  DatabaseModels.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import Foundation
import SwiftData

typealias AppModel = Codable & Identifiable

struct ModelDTO<T: PersistentModel>: Sendable {
    let persistentId: PersistentIdentifier
}

extension ModelDTO {
    init(_ model: T) {
        self.init(persistentId: model.persistentModelID)
    }
}

@Model
final class Recipe: AppModel, SortableModel {
    @Attribute(.unique)
    var id: String
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient]
    
    var name: String
    var categories: [Category]
    var cuisines: [Cuisine]
    var detail: String
    var prepTime: Double
    var totalTime: Double
    var instructions: [String]
    var label: String
    var createdOn: Date
    var modifiedOn: Date
    var isFavorite: Bool
    var timesCompleted: Int
    
    var prepTimeMeasurement: Measurement<UnitDuration> {
        return Measurement(value: prepTime, unit: .minutes)
    }
    var cookTimeMeasurement: Measurement<UnitDuration> {
        return Measurement(value: totalTime - prepTime, unit: .minutes)
    }
    var imageURL: URL? {
        return URL(string: image)
    }
    
    private var image: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, categories, cuisines, prepTime, totalTime, instructions, ingredients
        case createdOn, modifiedOn, isFavorite, timesCompleted
        case image = "imageUrl"
        case detail = "description"
        case label = "instanceDescription"
    }
    
    init(
        id: String,
        name: String,
        image: String,
        categories: [Category],
        cuisines: [Cuisine],
        detail: String,
        prepTime: Double,
        totalTime: Double,
        instructions: [String],
        ingredients: [Ingredient],
        label: String,
        createdOn: Date = .init(),
        modifiedOn: Date = .init(),
        isFavorite: Bool,
        timesCompleted: Int = 0
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.categories = categories
        self.cuisines = cuisines
        self.detail = detail
        self.prepTime = prepTime
        self.totalTime = totalTime
        self.instructions = instructions
        self.ingredients = ingredients
        self.label = label
        self.createdOn = createdOn
        self.modifiedOn = modifiedOn
        self.isFavorite = isFavorite
        self.timesCompleted = timesCompleted
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        categories = try container.decode([Category].self, forKey: .categories)
        cuisines = try container.decode([Cuisine].self, forKey: .cuisines)
        detail = try container.decode(String.self, forKey: .detail)
        prepTime = try container.decode(Double.self, forKey: .prepTime)
        totalTime = try container.decode(Double.self, forKey: .totalTime)
        instructions = try container.decode([String].self, forKey: .instructions)
        ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        label = try container.decode(String.self, forKey: .label)
        createdOn = try container
            .decodeIfPresent(Date.self, forKey: .createdOn) ?? .init()
        modifiedOn = try container
            .decodeIfPresent(Date.self, forKey: .modifiedOn) ?? .init()
        isFavorite = try container
            .decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        timesCompleted = try container
            .decodeIfPresent(Int.self, forKey: .timesCompleted) ?? 0
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
        try container.encode(categories, forKey: .categories)
        try container.encode(cuisines, forKey: .cuisines)
        try container.encode(detail, forKey: .detail)
        try container.encode(prepTime, forKey: .prepTime)
        try container.encode(totalTime, forKey: .totalTime)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(label, forKey: .label)
        try container.encode(createdOn, forKey: .createdOn)
        try container.encode(modifiedOn, forKey: .modifiedOn)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(timesCompleted, forKey: .timesCompleted)
    }
}

extension Recipe {
    static var sortItems: [SortItem<Recipe>: [SortOrderItem]] {
        [
            .init(\.createdOn, as: "Save Date"): [.latest, .oldest],
            .init(\.name, as: "Name"): [.az, .za],
        ]
    }
    
    static func getSortDescriptor(for keyPath: PartialKeyPath<Recipe>,
                                  order: SortOrder) -> SortDescriptor<Recipe> {
        switch keyPath {
        case \.name:
            return .init(\.name, order: order)
            
        default:
            return .init(\.createdOn, order: order)
        }
    }
}

@Model
final class Category: AppModel {
    @Attribute(.unique)
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Recipe.categories)
    var parent: [Recipe]?
    
    init(_ name: String) {
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(name)
    }
}

@Model
final class Cuisine: AppModel {
    @Attribute(.unique)
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Recipe.cuisines)
    var parent: [Recipe]?
    
    init(_ name: String) {
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(name)
    }
}

@Model
final class BaseIngredient: AppModel {
    @Attribute(.unique)
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.base)
    var parent: [Ingredient]?
    
    init(_ name: String) {
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(name)
    }
}

@Model
final class Ingredient: AppModel {
    var base: BaseIngredient
    var amount: String?
    var method: String?
    var label: String
    
    private enum CodingKeys: String, CodingKey {
        case amount, method
        case base = "name"
        case label = "instanceDescription"
    }
    
    init(
        base: String,
        amount: String? = nil,
        method: String? = nil,
        label: String
    ) {
        self.base = BaseIngredient(base)
        self.amount = amount
        self.method = method
        self.label = label
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        base = try container.decode(BaseIngredient.self, forKey: .base)
        amount = try container.decodeIfPresent(String.self, forKey: .amount)
        method = try container.decodeIfPresent(String.self, forKey: .method)
        label = try container.decode(String.self, forKey: .label)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(base, forKey: .base)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(method, forKey: .method)
        try container.encode(label, forKey: .label)
    }
}
