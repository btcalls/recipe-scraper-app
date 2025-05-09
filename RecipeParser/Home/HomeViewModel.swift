//
//  HomeViewModel.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import Combine

final class HomeViewModel: ViewModel, ObservableObject {
    typealias Value = [Test]
    
    @Published var data: [Test] = []
    @Published var isFetching: Bool = false
    
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
