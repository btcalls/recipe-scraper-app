//
//  Optional.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

extension Optional {
    /// Method to ease throwing errors in case of nil values in `Optional` instances.
    /// - Parameter errorExpression: The error to throw.
    /// - Returns: `Wrapped` instance, if available.
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            Debugger.critical(errorExpression())
            throw errorExpression()
        }
        
        return value
    }
}

extension Optional where Wrapped: Collection {
    /// Checks whether optional collection is `nil` or empty.
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
