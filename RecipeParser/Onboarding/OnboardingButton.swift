//
//  OnboardingButton.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingButton: View {
    var item: OnboardingItem
    
    var body: some View {
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
        .background(.gray)
        .cornerRadius(20)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    OnboardingButton(item: .init(title: "Hello, World!",
                                 caption: "Some description here.",
                                 icon: "globe"))
}

