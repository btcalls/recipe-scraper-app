//
//  ToastableView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 16/5/2025.
//

import SwiftUI

struct LoadableView<Content: View, VM: LoadableViewModel>: View {
    @ObservedObject var viewModel: VM
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .disabled(viewModel.isProcessing)
            .presentToast(as: $viewModel.state) {
                viewModel.state = nil
            }
    }
}
