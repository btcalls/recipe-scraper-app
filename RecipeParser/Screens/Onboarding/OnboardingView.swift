//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var selection = 0
    
    private var pages: [AnyView] {
        return [
            AnyView(
                OnboardingCard(
                    title: .onboardingItemOneTitle,
                    image: Image(.onboardingSearch),
                    description: Text(String.onboardingItemOneDesc)
                )
            ),
            AnyView(
                OnboardingCard(
                    title: .onboardingItemTwoTitle,
                    image: Image(.onboardingShare),
                    description: Text(String.onboardingItemTwoDesc)
                )
            ),
            AnyView(
                OnboardingCard(
                    title: .onboardingItemThreeTitle,
                    image: Image(.onboardingSave),
                    description: Text(String.onboardingItemThreeDesc)
                ) {
                    CustomButton(
                        .getStarted,
                        icon: .search, kind: .wide,
                        role: .confirm
                    ) {
                        coordinator.presentSheet(.browser)
                    }
                }
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: Layout.Scaled.interItem) {
            PageSelector(selection: $selection, pages: Array(0..<pages.count))
                .padding(.top, Layout.Padding.vertical)
            
            TabView(selection: $selection) {
                ForEach(Array(pages.indices), id: \.self) { index in
                    pages[index]
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.horizontal, Layout.Padding.comfortable)
        .appBackground()
    }
}

#Preview {
    OnboardingView()
        .modelContainer(.shared())
}
