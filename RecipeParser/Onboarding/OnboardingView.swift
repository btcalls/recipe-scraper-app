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
    @State private var showBrowserView: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15.0) {
            OnboardingButton(item: .init(title: .pasteURL,
                                         caption: .pasteURLDescription,
                                         icon: .documentOnClipboard)) {
                showPasteURLView = true
            }
            
            Divider()
            
            OnboardingButton(item: .init(title: .openBrowser,
                                         caption: .openBrowserDescription,
                                         icon: .globe)) {
                showBrowserView = true
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
        .sheet(isPresented: $showBrowserView) {
            showBrowserView = false
        } content: {
            BrowserView(url: URL(string: .googleURL)!)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}
