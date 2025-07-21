//
//  BoolBuilders.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/7/2025.
//

// MARK: Builders

@resultBuilder
struct OrBoolBuilder {
    static func buildPartialBlock(first: Bool) -> Bool {
        return first
    }
    
    static func buildPartialBlock(accumulated: Bool, next: Bool) -> Bool {
        return accumulated || next
    }
}

@resultBuilder
struct AndBoolBuilder {
    static func buildPartialBlock(first: Bool) -> Bool {
        return first
    }
    
    static func buildPartialBlock(accumulated: Bool, next: Bool) -> Bool {
        return accumulated && next
    }
}

// MARK: Utility functions

/// Result builder for performing logical AND operations to given Boolean operations.
/// - Parameter makeResult: The conditions to evaluate.
/// - Returns: `true` if all conditions were satisfied, else `false`.
func all(@AndBoolBuilder conditions makeResult: () -> Bool) -> Bool {
    return makeResult()
}

/// Result builder for performing logical OR operations to given Boolean operations.
/// - Parameter makeResult: The conditions to evaluate.
/// - Returns: `true` if at least one condition were satisfied, else `false`.
func either(@OrBoolBuilder conditions makeResult: () -> Bool) -> Bool {
    return makeResult()
}
