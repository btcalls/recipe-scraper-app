//
//  OnboardingButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingButton<Content: View>: View where Content: View {
    var title: String
    var image: Image
    var isEnabled: Bool = true
    var caption: () -> Content
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10.0) {
                image
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.largeTitle)
                Text(title)
                    .font(.title)
                caption()
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .padding(30)
            .multilineTextAlignment(.center)
        }
        .tint(.primary)
        .disabled(!isEnabled)
        .rounded(cornerRadius: 20, lineWidth: 2, color: .primary)
    }
}
