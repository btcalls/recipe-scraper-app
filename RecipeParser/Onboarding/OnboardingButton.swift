//
//  OnboardingButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingButton: View {
    var item: OnboardingItem
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10.0) {
                Image(systemName: item.icon)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.largeTitle)
                Text(item.title)
                    .font(.title)
                Text(item.caption)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .tint(.white)
        .rounded(cornerRadius: 20, lineWidth: 2, color: .primary)
    }
}

#Preview {
    OnboardingButton(item: .init(title: "Hello, World!",
                                 caption: "Some description here.",
                                 icon: "globe")) {
        // TODO: Pass
    }
}

