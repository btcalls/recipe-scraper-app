//
//  ToastModifier.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 15/5/2025.
//

import SwiftUI

private struct BackgroundView: View {
    @Binding var state: ToastView.State?
    
    var body: some View {
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
}

private struct MainView: View {
    @Binding var state: ToastView.State?
    
    var onDismiss: @MainActor () -> Void
    
    var body: some View {
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
}

struct ToastModifier: ViewModifier {
    @Binding var state: ToastView.State?
    
    var duration: ToastView.Duration
    var onDismiss: @MainActor () -> Void
    
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    MainView(state: $state, onDismiss: onDismiss)
                        .scale(.padding(.bottom), 20)
                }
                .background(BackgroundView(state: $state))
                .animation(.snappy, value: state)
            }
            .transition(.opacity)
            .onChange(of: state) {
                showToast()
            }
    }
    
    /// Present toast view and start task for auto-dismissal, if specified.
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
                
                // Assign task to dismiss toast after duration
                let task = DispatchWorkItem {
                    dismissToast()
                }
                
                workItem = task
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration,
                                              execute: task)
            }
        }
    }
    
    /// Dismiss toast view and reset tasks and state.
    private func dismissToast() {
        workItem?.cancel()
        
        workItem = nil
        state = nil
    }
}

struct TMPreviewView: View {
    @State private var state: ToastView.State?
    
    var body: some View {
        Button("Show Toast") {
            state = .success("Yey!")
        }
        .presentToast(as: $state, duration: .timed(3)) {
            state = nil
        }
    }
}

#Preview {
    TMPreviewView()
}
