//
//  DatabaseActor.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 17/6/2025.
//

import SwiftData
import Foundation

@ModelActor
actor DatabaseActor: Sendable {
    private var context: ModelContext {
        return modelExecutor.modelContext
    }
    
    /// Saves the data decoded as specified type to the persistent storage.
    /// - Parameters:
    ///   - data: The data to decode and save.
    ///   - type: The type the data is to be decoded as.
    func save<T: AppModel & PersistentModel>(data: Data, as type: T.Type) async throws {
        let model: T = try data.decoded()
        
        try await save(model: model)
    }
    
    /// Saves the model to the persistent storage.
    /// - Parameter model: The persistent model to store.
    func save<T: AppModel & PersistentModel>(model: T) async throws {
        context.insert(model)
        try context.save()
    }
}

extension DatabaseActor {
    /// Saves the `Recipe` instance to the persistent storage.
    /// - Parameter recipe: The persistent `Recipe` record to store.
    func save<T: Recipe>(recipe: T) async throws {
        recipe.modifiedOn = Date()
        
        context.insert(recipe)
        try context.save()
    }
}
