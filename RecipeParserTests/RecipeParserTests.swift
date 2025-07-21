//
//  RecipeParserTests.swift
//  RecipeParserTests
//
//  Created by Jason Jon Carreos on 17/4/2025.
//

import Testing
@testable import RecipeParser

struct RecipeParserTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func parseRecipes() async throws {
        let recipes = try MockService.shared.getRecipes()
        
        #expect(!recipes.isEmpty)
    }
    
}
