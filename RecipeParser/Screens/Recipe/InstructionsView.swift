//
//  InstructionsView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/7/2025.
//

import SwiftUI

struct InstructionsView: View {
    var items: [String]
    
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var index = 0
    
    private var instruction: String {
        return items[index]
    }
    private var step: String {
        if index == items.count - 1 {
            return "Last Step"
        }
        
        return "Step #\(index + 1)"
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            Spacer()
            
            Text(step)
                .font(.title)
                .fontWeight(.light)
                .scale(.padding(.vertical), 10)
                .scale(.padding(.horizontal), 15)
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
            
            Text(instruction)
                .lineSpacing(7.5)
                .font(.title3)
                .fontWeight(.semibold)
                .scale(.padding(.all), 20)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: .regular))
                .shadow()
            
            Spacer()
            
            BottomControlView {
                IconButton(.arrowLeft) {
                    if index != 0 {
                        index -= 1
                    }
                }
                .disabled(index == 0)
                
                IconButton(.arrowRight) {
                    if index < items.count - 1 {
                        index += 1
                    }
                }
                .disabled(index == items.count - 1)
            }
        }
        .scale(.padding(.horizontal), 20)
        .animation(
            .interactiveSpring(duration: 0.25),
            value: instruction
        )
        .presentationBackgroundInteraction(.disabled)
        .presentationBackground(.ultraThinMaterial)
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    RecipeView(recipe: MockService.shared.getRecipe())
        .fullScreenCover(isPresented: $isPresented) {
            InstructionsView(
                items: MockService.shared.getRecipe().instructions
            )
        }
}
