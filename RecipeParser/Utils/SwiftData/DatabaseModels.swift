//
//  DatabaseModels.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/6/2025.
//

import Foundation
import SwiftData

typealias AppModel = Codable & Identifiable
typealias DetailedInstruction = (title: String, instructions: [String])

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
    #Index<Recipe>([\.name, \.createdOn, \.isFavorite])
    
    @Attribute(.unique)
    var id: String
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient]
    
    var name: String
    var author: Author
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
    var categoriesLabel: String {
        return categories.map(\.name).joined(separator: " | ")
    }
    var cuisinesLabel: String {
        return cuisines.map(\.name).joined(separator: " | ")
    }
    var categoriesCuisinesLabel: String {
        return [categoriesLabel, cuisinesLabel].joined(separator: " | ")
    }
    var detailedInstructions: [DetailedInstruction] {
        let sectionIndices = instructions.enumerated().compactMap { (index, item) in
            isSection(item) ? index : nil
        }
        
        if sectionIndices.isEmpty {
            return [(String.instructions, instructions)]
        }
        
        let endIndices = sectionIndices.dropFirst() + [instructions.count]
        
        return zip(sectionIndices, endIndices).map { (start, end) in
            let title = instructions[start]
            let contentRange = (start + 1)..<end
            let items = contentRange.isEmpty ? [] : Array(
                instructions[contentRange]
            )
            
            return (title, items)
        }
    }
    
    private var image: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, author, categories, cuisines, prepTime, totalTime, instructions, ingredients
        case createdOn, modifiedOn, isFavorite, timesCompleted
        case image = "imageUrl"
        case detail = "description"
        case label = "instanceDescription"
    }
    
    init(
        id: String,
        name: String,
        author: Author,
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
        self.author = author
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
        author = try container.decode(Author.self, forKey: .author)
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
        try container.encode(author, forKey: .author)
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

private extension Recipe {
    func isSection(_ item: String) -> Bool {
        // NOTE: Add more keywords as necessary
        return either {
            item.hasSuffix("Instructions")
            item.hasPrefix("For the")
        }
    }
}

@Model
final class Author: AppModel {
    #Unique<Author>([\.name, \.website])
    
    var name: String
    var website: String
    
    init(name: String, website: String) {
        self.name = name
        self.website = website
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, website
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        website = try container.decode(String.self, forKey: .website)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(website, forKey: .website)
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

@Model
final class RecipeWeekMenu: AppModel {
    #Unique<RecipeWeekMenu>([\.recipeID, \.date])
    
    @Relationship(deleteRule: .nullify, inverse: \Recipe.id)
    var recipeID: String
    var name: String
    var imageURL: URL?
    var date: Date
    
    private enum CodingKeys: String, CodingKey {
        case recipeID = "id"
        case name, imageURL, date
    }
    
    init(
        recipeID: String,
        name: String,
        imageURL: URL? = nil,
        date: Date
    ) {
        self.recipeID = recipeID
        self.name = name
        self.imageURL = imageURL
        self.date = date
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recipeID = try container.decode(String.self, forKey: .recipeID)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(recipeID, forKey: .recipeID)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(date, forKey: .date)
    }
    
    static var withinThisWeek: FetchDescriptor<RecipeWeekMenu> {
        let now = Date.now
        let calendar = Calendar.current
        let startDate = calendar.dateComponents(
            [.calendar, .yearForWeekOfYear, .weekOfYear],
            from: now
        ).date!
        let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        let descriptor = FetchDescriptor<RecipeWeekMenu>(predicate: #Predicate {
            (startDate...endDate).contains($0.date)
        }, sortBy: [SortDescriptor(\.date)])
        
        return descriptor
    }
}
