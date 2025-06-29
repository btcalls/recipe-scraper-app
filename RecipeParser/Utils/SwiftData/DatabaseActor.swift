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
    
    func save<T: AppModel & PersistentModel>(data: Data, as type: T.Type) async throws {
        let model: T = try data.decoded()
        
        try await save(model: model)
    }
    
    func save<T: AppModel & PersistentModel>(model: T) async throws {
        context.insert(model)
        try context.save()
    }
}
