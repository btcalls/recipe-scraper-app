//
//  Array+Extensions.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

extension Array {
    /// Retrieves the previous element of the array in relation to the provided element.
    /// - Parameter element: The element to base the lookup of the previous element in the collection.
    /// - Returns: Optional. The previous element.
    func prev(_ element: Element) -> Element? where Element : Equatable {
        let index = firstIndex(of: element) ?? -1
        
        guard index > 0 else {
            return nil
        }
        
        return self[index - 1]
    }
    
    /// Retrieves the next element of the array in relation to the provided element.
    /// - Parameter element: The element to base the lookup of the next element in the collection.
    /// - Returns: Optional. The next element.
    func next(_ element: Element) -> Element? where Element : Equatable {
        let index = firstIndex(of: element) ?? -1
        
        guard index + 1 < count else {
            return nil
        }
        
        return self[index + 1]
    }
}
