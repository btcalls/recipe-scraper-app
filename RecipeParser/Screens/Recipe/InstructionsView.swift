//
//  InstructionsView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/7/2025.
//

import SwiftUI

struct InstructionsView: View {
    var instructions: [String]
    
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var current = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            Text(instructions[current])
                .lineSpacing(7.5)
                .font(.title3)
                .fontWeight(.semibold)
                .scale(.padding(.all), 20)
        }
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: .regular))
        .shadow()
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    RecipeView(recipe: MockService.shared.getRecipe())
        .fullScreenCover(isPresented: $isPresented) {
            InstructionsView(
                instructions: MockService.shared.getRecipe().instructions
            )
            .presentationBackgroundInteraction(.disabled)
            .presentationBackground(.ultraThinMaterial)
        }
}
