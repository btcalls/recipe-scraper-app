//
//  ToastableView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 16/5/2025.
//

import SwiftUI

struct LoadableView<Content: View>: View {
    @ObservedObject var viewState: ViewState
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .disabled(viewState.isProcessing)
            .presentToast(as: $viewState.toast) {
                viewState.toast = nil
            }
    }
}
