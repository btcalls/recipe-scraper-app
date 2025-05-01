//
//  HomeViewModel.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 2/5/2025.
//

import Foundation
import Combine

final class HomeViewModel: ViewModel, ObservableObject {
    typealias Value = [Post]
    
    @Published var data: [Post] = []
    @Published var error: CustomError?
    @Published var isFetching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        isFetching = true
        
        APIClient.shared.send(PostRequest(endpoint: .getPosts))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isFetching = false
                
                switch completion {
                case .failure(let e):
                    self?.error = e as? CustomError
                    
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.data = response
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        fetchData()
    }
}
