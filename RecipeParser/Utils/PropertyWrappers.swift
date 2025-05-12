//
//  PropertyWrappers.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 12/5/2025.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Value> {
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    
    init(wrappedValue defaultValue: Value, key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    var wrappedValue: Value {
        get {
            storage.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
