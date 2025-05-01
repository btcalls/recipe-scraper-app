//
//  Untitled.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State var isOnboardingComplete: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {
            OnboardingButton(item: .init(title: "Paste URL",
                                         caption: "Select a Recipe Website's URL and paste it here.",
                                         icon: "document.on.clipboard"))
            Divider()
            OnboardingButton(item: .init(title: "Open Browser",
                                         caption: "Search the recipe from the in-built browser. Click on the \"Save\" button to start parsing.",
                                         icon: "globe"))
        }
        .background(.red)
        .padding(20)
    }
}

#Preview {
    OnboardingView()
}
