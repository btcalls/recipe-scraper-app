//
//  Models.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import UIKit
import SwiftData

struct RecipeMetadata {
    var title: String
    var description: String
    var hostName: String
    var image: UIImage? = nil
    var icon: UIImage? = nil
}

// MARK: Persistent Models

typealias AppModel = Codable & Identifiable

struct Model<T: PersistentModel>: Sendable {
    let persistentId: PersistentIdentifier
}

extension Model {
    init(_ model: T) {
        self.init(persistentId: model.persistentModelID)
    }
}

@Model
final class Recipe: AppModel {
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
    
    var prepTimeMeasurement: Measurement<UnitDuration> {
        return Measurement(value: prepTime, unit: .minutes)
    }
    var cookTimeMeasurement: Measurement<UnitDuration> {
        return Measurement(value: totalTime - prepTime, unit: .minutes)
    }
    
    private var image: String
    
    var imageURL: URL? {
        return URL(string: image)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, categories, cuisines, prepTime, totalTime, instructions, ingredients
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
        label: String
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
        self.createdOn = .init()
        self.modifiedOn = .init()
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
        createdOn = .init()
        modifiedOn = .init()
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

extension Recipe {
    static var sample: Recipe {
        if let obj = try? Recipe.fromJSONFile("sample_data") {
            return obj
        }
        
        return .init(
            id: "asdf-dfd",
            name: "Homemade Burger",
            image: "https://realfood.tesco.com/media/images/1400x919HawaiianBurger-39059ab5-b8bb-4147-b927-70fc1a88bfc5-0-1400x919.jpg",
            categories: [.init("Main"), .init("Afternoon Tea")],
            cuisines: [.init("American"), .init("Pacific")],
            detail: "Tasty burger",
            prepTime: 20,
            totalTime: 40,
            instructions: [""],
            ingredients: [],
            label: ""
        )
    }
}
