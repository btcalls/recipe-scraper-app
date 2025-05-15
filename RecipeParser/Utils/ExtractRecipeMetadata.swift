//
//  ExtractRecipeMetadata.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 7/5/2025.
//

import LinkPresentation
import UniformTypeIdentifiers

final class ExtractRecipeMetadata {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    /// Starts parsing of provided URL upon initialisation to its corresponding `RecipeMetadata` instance.
    /// - Returns: `RecipeMetadata` derived from URL, if available.
    func parse() async throws -> RecipeMetadata {
        let provider = LPMetadataProvider()
        let metadata = try await provider.startFetchingMetadata(for: url)
        var recipeMetadata = RecipeMetadata(
            title: metadata.title ?? "",
            description: metadata.value(forKey: "_summary") as? String ?? "",
            hostName: url.host ?? ""
        )
        
        if let image = await metadata.imageProvider?.loadImageRepresentation(for: .image) {
            recipeMetadata.image = image
        }
        
        if let icon = await metadata.iconProvider?.loadImageRepresentation(for: .image) {
            recipeMetadata.icon = icon
        }
        
        return recipeMetadata
    }
}
