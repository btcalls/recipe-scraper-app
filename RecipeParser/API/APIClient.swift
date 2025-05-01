//
//  APIClient.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extract data from response
            .decode(type: [Post].self, decoder: JSONDecoder()) // Decode JSON into array of Posts
            .replaceError(with: []) // Replace errors with an empty array
            .receive(on: DispatchQueue.main) // Receive on main queue to update UI
            .sink(receiveValue: { [weak self] fetchedPosts in
                self?.posts = fetchedPosts // Update posts with fetched data
            })
    }
}
