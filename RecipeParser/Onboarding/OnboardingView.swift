//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isOnboardingComplete: Bool = false
    @State private var showPasteURLView: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15.0) {
            OnboardingButton(item: .init(title: "Paste URL",
                                         caption: "Select a Recipe Website's URL and paste it here.",
                                         icon: .documentOnClipboard)) {
                showPasteURLView = true
            }
            Divider()
                .frame(height: 2)
                .overlay(Color.primary)
            OnboardingButton(item: .init(title: "Open Browser",
                                         caption: "Search the recipe from the in-built browser. Click on the \"Save\" button to start parsing.",
                                         icon: .globe)) {
                Debugger.print("Open Browser")
            }
        }
        .padding(20)
        .sheet(isPresented: $showPasteURLView) {
            showPasteURLView = false
        } content: {
            PasteURLView()
                .presentationDetents([.fraction(0.4)])
                .presentationBackground(.thinMaterial)
        }
    }
}

#Preview {
    OnboardingView()
}
