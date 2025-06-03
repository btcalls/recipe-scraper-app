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
    
    @ViewBuilder private func backgroundView() -> some View {
        switch state {
        case .loading(_:):
            Color.secondary
                .opacity(0.5)
                .ignoresSafeArea(.all)
                .transition(.opacity)
        
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder private func mainToastView() -> some View {
        if let state {
            VStack {
                Spacer()
                
                ToastView(state: state, onDismiss: onDismiss)
            }
            .scale(.padding(.horizontal), 10)
            .transition(.asymmetric(insertion: .move(edge: .bottom),
                                    removal: .opacity))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    mainToastView()
                        .scale(.padding(.bottom), 20)
                }
                .background(backgroundView())
                .animation(.snappy, value: state)
            }
            .transition(.opacity)
            .onChange(of: state) {
                showToast()
            }
    }
    
    private func showToast() {
        guard let _ = state else {
            return
        }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        // Prevent automatic dismissal if presented as a loading toast
        if case .loading(_:) = state {
            return
        }
        
        // Handle auto-dismissal
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
            state = .loading(.processing)
        }
        .presentToast(as: $state) {
            state = nil
        }
    }
}

#Preview {
    PreviewView()
}
