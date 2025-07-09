//
//  InstructionsView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/7/2025.
//

import SwiftUI

struct InstructionsView: View {
    var items: [String]
    var onComplete: @MainActor () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric private var spacing: CGFloat = 20
    @State private var index = 0
    @State private var isCookCompleted = false
    
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
        ZStack(alignment: .topTrailing) {
            IconButton(.x, kind: .muted) {
                dismiss()
            }
            .imageScale(.large)
            
            VStack(alignment: .center, spacing: spacing) {
                Spacer()
                
                Text(step)
                    .font(.title2)
                    .fontWeight(.light)
                    .scale(.padding(.vertical), 10)
                    .scale(.padding(.horizontal), 15)
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
                
                Text(instruction)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    IconButton(.checkmark, size: .lg) {
                        isCookCompleted.toggle()
                    }
                    .remove(if: index != items.count - 1)
                    
                    IconButton(.arrowRight) {
                        if index < items.count - 1 {
                            index += 1
                        }
                    }
                    .disabled(index == items.count - 1)
                }
                .animation(
                    .customInteractiveSpring,
                    value: instruction
                )
            }
            .animation(.customEaseInOut, value: instruction)
            .presentationBackgroundInteraction(.disabled)
            .presentationBackground(.ultraThinMaterial)
        }
        .alert(String.success, isPresented: $isCookCompleted) {
            Button(String.markComplete) {
                dismiss()
                onComplete()
            }
            
            Button(String.cancel, role: .cancel) {}
        } message: {
            Text(String.cookCompleteConfirmation)
        }
        .scale(.padding(.horizontal), 20)
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    RecipeView(recipe: MockService.shared.getRecipe())
        .fullScreenCover(isPresented: $isPresented) {
            InstructionsView(
                items: MockService.shared.getRecipe().instructions
            ) {
                // No-op
            }
        }
}
