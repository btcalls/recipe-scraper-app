//
//  HomeViewModel.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import Combine

final class HomeViewModel: ViewModel, ObservableObject {
    typealias Value = [Recipe]
    
    @Published var data: [Recipe] = []
    @Published var isProcessing: Bool = false
    @Published var error: CustomError?
    
    @MainActor
    func fetchData() async throws {
        defer {
            isProcessing = false
        }
        
        isProcessing = true
        data = []
    }
    
    @MainActor
    func reloadData() async throws {
        try await fetchData()
    }
}
