//
//  ToastModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 15/5/2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var state: ToastView.State?
    
    @State private var workItem: DispatchWorkItem?
    
    var duration: ToastView.Duration
    var onDismiss: @MainActor () -> Void
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    mainToastView()
                        .padding(.bottom, 30)
                }
                .animation(.snappy, value: state)
            }
            .onChange(of: state) {
                showToast()
            }
    }
    
    @ViewBuilder private func mainToastView() -> some View {
        if let state {
            VStack {
                Spacer()
                
                ToastView(state: state, onDismiss: onDismiss)
            }
            .padding(.horizontal, 10)
            .transition(.asymmetric(insertion: .move(edge: .bottom),
                                    removal: .opacity))
        }
    }
    
    private func showToast() {
        guard let _ = state else {
            return
        }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        switch duration {
        case .indefinite:
            return
        
        case .timed(let duration):
            if duration > 0 {
                workItem?.cancel()
                
                let task = DispatchWorkItem {
                    dismissToast()
                }
                
                workItem = task
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration,
                                              execute: task)
            }
        }
    }
    
    private func dismissToast() {
        workItem?.cancel()
        
        workItem = nil
        state = nil
    }
}

struct PreviewView: View {
    @State private var state: ToastView.State?
    
    var body: some View {
        Button("Show Toast") {
            state = .success("Hooray!")
        }
        .presentToast(as: $state) {
            state = nil
        }
    }
}

#Preview {
    PreviewView()
}
