//
//  ToastableView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 16/5/2025.
//

import SwiftUI

struct ToastableView<Content: View, VM: LoadableViewModel>: View {
    @StateObject var viewModel: VM
    
    var content: () -> Content
    
    var body: some View {
        content()
            .presentToast(as: $viewModel.state) {
                viewModel.state = nil
            }
    }
}
