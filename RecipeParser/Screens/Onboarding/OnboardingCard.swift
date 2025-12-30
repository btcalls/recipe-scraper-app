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
                .clipShape(.rect(corners: .concentric(minimum: .large)))
                .containerRelativeFrame(.vertical,
                                        count: 100,
                                        span: 50,
                                        spacing: 0)
                .padding(.horizontal, Layout.Padding.horizontal)
            
            Text(title)
                .font(.largeTitle)
                .foregroundStyle(Color.appForeground)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            caption
                .foregroundStyle(Color.appForeground)
                .lineLimit(3)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if let (title, handler) = action {
                CustomButton(title, kind: .wide, action: handler)
            }
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.horizontal, Layout.Padding.horizontal)
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
