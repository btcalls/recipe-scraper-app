//
//  InstructionsView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 8/7/2025.
//

import SwiftUI

struct InstructionsView: View {
    var items: [DetailedInstruction]
    var onComplete: @MainActor () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var isCookCompleted = false
    @State private var index = 0
    @State private var sectionIndex = 0
    @State private var isPrevDisabled = true
    @State private var isNextDisabled = false
    
    private var section: DetailedInstruction {
        return items[sectionIndex]
    }
    private var title: String? {
        if items.count == 1 {
            return nil
        }
        
        return section.title
    }
    private var instruction: String {
        return section.instructions[index]
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            HStack {
                Spacer()
                
                IconButton(.x, kind: .muted) {
                    dismiss()
                }
                .imageScale(.large)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    if let title {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.light)
                            .lineLimit(2)
                        
                        Divider()
                            .asStandard()
                            .scale(.padding(.vertical), 10)
                    }
                    
                    Text(instruction)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(7.5)
                        .font(.title3)
                        .fontWeight(.semibold)
                        
                }
                .scale(.padding(.all), 20)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: .regular))
                .shadow()
            }
            .scrollIndicators(.automatic)
            .scrollClipDisabled()
            .scrollBounceBehavior(.basedOnSize)
            .scale(.padding(.top), 20)
            
            Spacer()
            
            BottomControlView {
                IconButton(.arrowLeft) {
                    prev()
                }
                .disabled(isPrevDisabled)
                
                IconButton(.checkmark, size: .lg) {
                    isCookCompleted.toggle()
                }
                .remove(if: !isNextDisabled)
                
                IconButton(.arrowRight) {
                    next()
                }
                .disabled(isNextDisabled)
            }
            .animation(
                .customInteractiveSpring,
                value: instruction
            )
        }
        .animation(.customEaseInOut, value: instruction)
        .presentationBackgroundInteraction(.disabled)
        .presentationBackground(.ultraThinMaterial)
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
    
    private func prev() {
        isNextDisabled = false
        
        // Navigate to previous instruction
        if index != 0 {
            index -= 1
        } else {
            // Navigate to previous instruction of previous section
            if sectionIndex > 0 {
                sectionIndex -= 1
            }
            
            index = section.instructions.endIndex - 1
        }
        
        // Reached start of recipe
        if index == 0 && sectionIndex == 0 {
            isPrevDisabled = true
        }
    }
    
    private func next() {
        isPrevDisabled = false
        
        // Navigate to next instruction for current section
        if index < section.instructions.endIndex - 1 {
            index += 1
        } else {
            // Navigate to first item of next section
            if sectionIndex < items.endIndex - 1 {
                sectionIndex += 1
                index = 0
            }
        }
        
        // Reached end of recipe instructions
        if index == section.instructions.endIndex - 1 &&
            sectionIndex == items.endIndex - 1 {
            isNextDisabled = true
        }
    }
}

#Preview {
    InstructionsView(
        items: MockService.shared.getRecipe().detailedInstructions
    ) {
        // No-op
    }
}
