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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    if let title {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                        
                        Divider()
                            .asStandard()
                            .scale(.padding(.vertical), 10)
                    }
                    
                    Text(instruction)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(7.5)
                        .font(.title3)
                        .fontWeight(.regular)
                        
                }
            }
            .toolbar {
                Button(.x, role: .close) {
                    dismiss()
                }
                
                Button(.checkmark, role: .confirm) {
                    isCookCompleted.toggle()
                }
                .remove(if: !isNextDisabled)
            }
            .safeAreaBar(edge: .bottom, content: {
                GlassEffectContainer {
                    HStack {
                        IconButton(.arrowLeft) {
                            prev()
                        }
                        .disabled(isPrevDisabled)
                        
                        IconButton(.arrowRight) {
                            next()
                        }
                        .disabled(isNextDisabled)
                    }
                }
            })
            .scrollIndicators(.automatic)
            .scrollClipDisabled()
            .scrollBounceBehavior(.basedOnSize)
            .scale(.padding(.horizontal), 20)
        }
        .presentationBackgroundInteraction(.disabled)
        .presentationDetents([.fraction(0.5), .fraction(0.75), .large])
        .alert(String.success, isPresented: $isCookCompleted) {
            Button(String.markComplete) {
                dismiss()
                onComplete()
            }
            
            Button(String.cancel, role: .cancel) {}
        } message: {
            Text(String.cookCompleteConfirmation)
        }
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
    @Previewable @State var isPresenting = true
    
    VStack {
        Toggle(isOn: $isPresenting) {
            Text("Present")
        }
    }
    .sheet(isPresented: $isPresenting) {
        InstructionsView(
            items: MockService.shared.getRecipe().detailedInstructions
        ) {
            // No-op
        }
    }
}
