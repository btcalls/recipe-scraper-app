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
    
    @ScaledMetric private var spacing: CGFloat = 20
    
    @ViewBuilder let caption: Content
    
    var action: (title: String, handler: (() -> Void))?
    
    var body: some View {
        VStack(spacing: spacing) {
            image
                .resizable()
                .scaledToFit()
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
                .shadow()
            
            caption
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .scale(.padding(.horizontal), 20)
            
            Spacer()
            
            if let (title, handler) = action {
                Button(action: handler) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .scale(.padding(.horizontal), 20)
                        .scale(.padding(.vertical), 10)
                }
                .rounded(cornerRadius: .regular, lineWidth: 1, color: .white)
                .tint(.white)
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
        .cornerRadius(CornerRadius.lg.rawValue)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingCard(
        title: .onboardingItemOneTitle,
        image: Image("Placeholder"),
        caption: {
            Text(String.onboardingItemOneDesc)
        },
        action: (.getStarted, {}))
}
