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
    @Published var isFetching: Bool = false
    @Published var error: CustomError? = nil
    
    @MainActor
    func fetchData() async throws {
        isFetching = true
        data = try await APIClient.shared.send(HomeEndpoints.getPosts)
    }
    
    @MainActor
    func reloadData() async throws {
        try await fetchData()
    }
}
