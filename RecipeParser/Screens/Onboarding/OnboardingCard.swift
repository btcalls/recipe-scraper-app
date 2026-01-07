//
//  OnboardingCard.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/5/2025.
//

import SwiftUI

struct OnboardingCard<Content>: View where Content : View {
    let title: String
    let image: Image
    let description: Text
    @ViewBuilder let actionAccessory: () -> Content
    
    @ScaledMetric private var spacing = Layout.Scaled.spacing
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            image
                .resizable()
                .scaledToFit()
                .clipShape(.rect(corners: .concentric(minimum: .large)))
                .containerRelativeFrame(.vertical,
                                        count: 100,
                                        span: 50,
                                        spacing: 0)
                .padding(.horizontal, Layout.Padding.horizontal)
                .padding(.top, Layout.Padding.vertical)
                .shadow()
            
            Text(title)
                .font(.largeTitle)
                .foregroundStyle(Color.appForeground)
                .fontWeight(.semibold)
                .lineLimit(2)
                .padding(.top, Layout.Padding.comfortable)
            
            description
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.appForeground)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            actionAccessory()
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
    }
}

extension OnboardingCard where Content == EmptyView {
    init(title: String, image: Image, description: Text) {
        self.title = title
        self.image = image
        self.description = description
        self.actionAccessory = { EmptyView() }
    }
}

#Preview {
    OnboardingView()
}

