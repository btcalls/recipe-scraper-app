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
        let obj: T = try data.decoded()
        
        context.insert(obj)
        try context.save()
    }
}
