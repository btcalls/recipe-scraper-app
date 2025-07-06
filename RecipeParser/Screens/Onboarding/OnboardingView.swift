//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppSettings.self) private var appSettings
    @State private var isBrowserPresented = false
    
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
                    isBrowserPresented = true
                })
            ) {
                Text(String.onboardingItemTwoDesc)
            }
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 20)
        .sheet(isPresented: $isBrowserPresented) {
            isBrowserPresented = false
            
            if AppValues.shared.isOnboardingComplete {
                withAnimation {
                    appSettings.rootView = .home
                }
            }
        } content: {
            BrowserView()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AppSettings())
        .modelContainer(.shared())
}
