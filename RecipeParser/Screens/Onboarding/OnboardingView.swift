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
    
    private var pages: [OnboardingCard<Text>] {
        return [
            .init(
                title: .onboardingItemOneTitle,
                image: Image("Placeholder")
            ) {
                Text(String.onboardingItemOneDesc)
            },
            .init(
                title: .onboardingItemTwoTitle,
                image: Image("Placeholder"),
                action: (.getStarted, {
                    coordinator.presentSheet(.browser)
                })
            ) {
                Text(String.onboardingItemTwoDesc)
            }
        ]
    }
    
    var body: some View {
        VStack(spacing: Layout.Scaled.interItem) {
            TabView(selection: $selection) {
                ForEach(pages.enumerated(), id: \.element.title) { index, view in
                    view.tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.vertical, Layout.Padding.horizontal)
            
            PageSelector(selection: $selection, pages: Array(0..<pages.count))
                .padding(.bottom, Layout.Padding.vertical)
        }
        .appBackground()
    }
}

#Preview {
    OnboardingView()
        .modelContainer(.shared())
}
