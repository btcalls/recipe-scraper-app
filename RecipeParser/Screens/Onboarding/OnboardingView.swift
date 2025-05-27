//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @State private var isBrowserPresented = false
    
    var body: some View {
        TabView {
            OnboardingCard(
                title: .onboardingItemOneTitle,
                image: Image("Placeholder"),
                caption: {
                    Text(String.onboardingItemOneDesc)
                }
            )
            .tag(0)
            
            OnboardingCard(
                title: .onboardingItemTwoTitle,
                image: Image("Placeholder"),
                caption: {
                    Text(String.onboardingItemTwoDesc)
                },
                action: (.getStarted, {
                    isBrowserPresented = true
                })
            )
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 20)
        .sheet(isPresented: $isBrowserPresented) {
            isBrowserPresented = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if AppValues.shared.isOnboardingComplete {
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
}
