//
//  OnboardingCard.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/5/2025.
//

import SwiftUI

struct OnboardingCard<Content>: View where Content : View {
    var title: String
    var image: Image
    var action: (title: String, handler: (@MainActor () -> Void))?
    
    @ViewBuilder let caption: Content
    
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    
    var body: some View {
        VStack(spacing: spacing) {
            image
                .resizable()
                .scaledToFit()
                .clipShape(.rect(corners: .concentric(minimum: .small)))
                .shadow()
                .containerRelativeFrame(.vertical,
                                        count: 100,
                                        span: 60,
                                        spacing: 0)
            
            Text(title)
                .font(.largeTitle)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .lineLimit(2)
                .scale(.padding(.horizontal), 20)
            
            caption
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .scale(.padding(.horizontal), 20)
            
            Spacer()
            
            if let (title, handler) = action {
                WideButton(title, action: handler)
            }
            
            Spacer()
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(Layout.CornerRadius.medium.rawValue)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingCard(
        title: .onboardingItemOneTitle,
        image: Image("Placeholder"),
        action: (.getStarted, {})
    ) {
        Text(String.onboardingItemOneDesc)
    }  
}
