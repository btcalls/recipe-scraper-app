//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        TabView {
            OnboardingCard(
                title: .onboardingItemOneTitle,
                image: Image("Placeholder")
            ) {
                Text(String.onboardingItemOneDesc)
            }
            .tag(0)
            
            OnboardingCard(
                title: .onboardingItemTwoTitle,
                image: Image("Placeholder"),
                action: (.getStarted, {
                    coordinator.presentSheet(.browser)
                })
            ) {
                Text(String.onboardingItemTwoDesc)
            }
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 20)
    }
}

#Preview {
    OnboardingView()
        .modelContainer(.shared())
}
