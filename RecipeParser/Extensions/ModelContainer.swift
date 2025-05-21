//
//  ModelContainer.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 19/5/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var shared: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            Ingredient.self
        ])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false,
                                                    groupContainer: .identifier(.extensionGroup))
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

extension ModelContext {
    /// Retrieves the `PersistentModel` instance.
    /// - Parameter model: `Model` instance in which the persistent model is wrapped.
    /// - Returns: Optional.  The model of type `T`.
    func getModel<T>(_ model: Model<T>) throws -> T? where T: PersistentModel {
        try self.persistentModel(withID: model.persistentId)
    }
    
    /// Queries for data from given ID.
    /// - Parameter objectID: The identifier in which queries will be based of.
    /// - Returns: Optional. The model of type `T`.
    private func persistentModel<T>(withID objectID: PersistentIdentifier) throws -> T? where T: PersistentModel {
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
