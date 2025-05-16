//
//  NSItemProvider.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import UIKit
import UniformTypeIdentifiers

extension NSItemProvider {
    /// Wrapper for `loadDataRepresentation` to be callable via `async/await` mechanism.
    /// - Parameter type: The type of data to load.
    /// - Returns: Optional. `UIImage` instance loaded from data.
    func loadImageRepresentation(for type: UTType) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            _ = loadDataRepresentation(for: type) { data, error in
                guard let data else {
                    continuation.resume(returning: nil)
                    
                    return
                }
                
                continuation.resume(returning: UIImage(data: data))
            }
        }
    }
}
