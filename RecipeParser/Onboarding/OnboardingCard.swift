//
//  OnboardingCard.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/5/2025.
//

import SwiftUI

struct OnboardingCard<Content>: View where Content : View {
    @State private var isAnimating: Bool = false
    
    var title: String
    var image: Image
    var caption: () -> Content
    var action: (title: String, handler: (() -> Void))?
    
    var body: some View {
        VStack(spacing: 20) {
            image
                .resizable()
                .scaledToFit()
                .shadow()
                .containerRelativeFrame(.vertical, count: 100, span: 65, spacing: 0)
            
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .shadow()
            
            caption()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .frame(maxWidth: 480)
            
            Spacer()
            
            if let (title, handler) = action {
                Button(action: handler) {
                    Text(title)
                        .fontWeight(.medium)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .rounded(cornerRadius: .regular, lineWidth: 1, color: .white)
                .tint(.white)
                .offset(y: -50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingCard(title: "Test", image: Image("Placeholder"), caption: {
        Text("Some description")
    }, action: (.getStarted, {
        // TODO: Pass
    }))
}
