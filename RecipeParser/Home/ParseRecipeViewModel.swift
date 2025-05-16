//
//  ParseRecipeViewModel.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 14/5/2025.
//

import Foundation
import Combine

final class ParseRecipeViewModel: ProcessViewModel {
    typealias Body = URL
    typealias Value = Recipe?
    
    @Published var data: Recipe?
    @Published var isFetching: Bool = false
    @Published var error: CustomError?
    @Published var state: ToastView.State? = nil
    
    @MainActor
    func process(_ body: URL) async {
        defer {
            isFetching = false
        }
        
        isFetching = true
        
        do {
            data = try await APIClient.shared.send(
                HomeEndpoints.parseRecipe(body)
            )
            
            if let data {
                // TODO: Save viewModel.data to local storage
                Debugger.print(data)
            }
        } catch(let e) {
            if let customError = e as? CustomError {
                error = customError
                state = .error(customError)
            }
        }
    }
}
