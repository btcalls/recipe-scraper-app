//
//  ModelContainer.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 19/5/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    /// The schema used for configuring the app's model container.
    static let schema = Schema([
        Recipe.self,
        Category.self,
        Cuisine.self,
        Ingredient.self,
        BaseIngredient.self,
        RecipeWeekMenu.self,
    ])
    
    /// The `ModelContainer` instance configured and used across the application.
    /// - Returns: Configured `ModelContainer` instance.
    static func shared() -> ModelContainer {
        let modelConfiguration = ModelConfiguration(schema: Self.schema,
                                                    groupContainer: .identifier(.extensionGroup))
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

extension ModelContext {
    /// Retrieves the `PersistentModel` instance.
    /// - Parameter model: `Model` instance in which the persistent model is wrapped.
    /// - Returns: Optional.  The model of type `T`.
    func getModel<T>(_ model: ModelDTO<T>) throws -> T? where T : PersistentModel {
        return try self.persistentModel(withID: model.persistentId)
    }
    
    /// Checks whether persistent model is available in current context.
    /// - Parameter model: `Model` in which the `persistentId` is used for lookup.
    /// - Returns: Boolean flag for instance availability.
    func hasModel<T>(_ model: ModelDTO<T>) -> Bool where T : PersistentModel {
        let obj: T? = try? getModel(model)
        
        return obj != nil
    }
    
    /// Queries for data from given ID.
    /// - Parameter objectID: The identifier in which queries will be based of.
    /// - Returns: Optional. The model of type `T`.
    private func persistentModel<T>(withID objectID: PersistentIdentifier) throws -> T? where T : PersistentModel {
        if let registered: T = registeredModel(for: objectID) {
            return registered
        }
        
        if let notRegistered: T = model(for: objectID) as? T {
            return notRegistered
        }
        
        let fetchDescriptor = FetchDescriptor<T>(
            predicate: #Predicate { $0.persistentModelID == objectID }
        )
        
        return try fetch(fetchDescriptor).first
    }
}
