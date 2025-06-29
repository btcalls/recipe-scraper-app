//
//  Array+Extensions.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/5/2025.
//

extension Array where Element : Equatable {
    /// Retrieves the previous element of the array in relation to the provided element.
    /// - Parameter element: The element to base the lookup of the previous element in the collection.
    /// - Returns: Optional. The previous element.
    func prev(_ element: Element) -> Element? {
        let index = firstIndex(of: element) ?? -1
        
        guard index > 0 else {
            return nil
        }
        
        return self[index - 1]
    }
    
    /// Retrieves the next element of the array in relation to the provided element.
    /// - Parameter element: The element to base the lookup of the next element in the collection.
    /// - Returns: Optional. The next element.
    func next(_ element: Element) -> Element? {
        let index = firstIndex(of: element) ?? -1
        
        guard index + 1 < count else {
            return nil
        }
        
        return self[index + 1]
    }
    
    /// Retrieves the adjacent item of provided `Element`, else defaults to fallback value.
    /// - Parameters:
    ///   - item: The current item in question.
    ///   - defaultItem: Fallback item if adjacent element is unavailable.
    ///   - reverse: Flag whether to cycle to previous element or to the next.
    /// - Returns: The adjacent `Element`.
    func cycle(_ item: Element?,
               fallback defaultItem: Element,
               reverse: Bool = false) -> Element {
        switch reverse {
        case false:
            if let item, let next = self.next(item) {
                return next
            } else {
                return defaultItem
            }
        
        case true:
            if let item, let prev = self.prev(item) {
                return prev
            } else {
                return defaultItem
            }
        }
    }
}
