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
    var category: String
    var cuisine: String
    var detail: String
    var prepTime: Double
    var totalTime: Double
    var instructions: [String]
    var _description: String
    var createdOn: Date
    var modifiedOn: Date
    
    var cuisineCategory: String {
        return "\(cuisine) • \(category)"
    }
    
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
        case id, name, category, cuisine, prepTime, totalTime, instructions, ingredients
        case image = "imageUrl"
        case detail = "description"
        case _description = "instanceDescription"
    }
    
    init(
        id: String,
        name: String,
        image: String,
        category: String,
        cuisine: String,
        detail: String,
        prepTime: Double,
        totalTime: Double,
        instructions: [String],
        ingredients: [Ingredient],
        _description: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.category = category
        self.cuisine = cuisine
        self.detail = detail
        self.prepTime = prepTime
        self.totalTime = totalTime
        self.instructions = instructions
        self.ingredients = ingredients
        self._description = _description
        self.createdOn = .init()
        self.modifiedOn = .init()
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        category = try container.decode(String.self, forKey: .category)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        detail = try container.decode(String.self, forKey: .detail)
        prepTime = try container.decode(Double.self, forKey: .prepTime)
        totalTime = try container.decode(Double.self, forKey: .totalTime)
        instructions = try container.decode([String].self, forKey: .instructions)
        ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        _description = try container.decode(String.self, forKey: ._description)
        createdOn = .init()
        modifiedOn = .init()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
        try container.encode(category, forKey: .category)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(detail, forKey: .detail)
        try container.encode(prepTime, forKey: .prepTime)
        try container.encode(totalTime, forKey: .totalTime)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(_description, forKey: ._description)
    }
}

extension Recipe {
    static var sample: Recipe {
        if let obj: Recipe = try? Recipe.fromJSONFile("sample_data") {
            return obj
        }
        
        return .init(
            id: "asdf-dfd",
            name: "Burger",
            image: "https://realfood.tesco.com/media/images/1400x919HawaiianBurger-39059ab5-b8bb-4147-b927-70fc1a88bfc5-0-1400x919.jpg",
            category: "Main",
            cuisine: "American",
            detail: "Tasty burger",
            prepTime: 20,
            totalTime: 40,
            instructions: [""],
            ingredients: [],
            _description: ""
        )
    }
}

@Model
final class Ingredient: AppModel {
    @Attribute(.unique)
    var id: String
    
    var name: String
    var amount: String?
    var method: String?
    var label: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, method
        case label = "instanceDescription"
    }
    
    init(
        id: String,
        name: String,
        amount: String? = nil,
        method: String? = nil,
        label: String
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.method = method
        self.label = label
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        amount = try container.decodeIfPresent(String.self, forKey: .amount)
        method = try container.decodeIfPresent(String.self, forKey: .method)
        label = try container.decode(String.self, forKey: .label)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(method, forKey: .method)
        try container.encode(label, forKey: .label)
    }
}
