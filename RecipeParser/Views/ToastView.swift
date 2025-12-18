//
//  ToastView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 15/5/2025.
//

import SwiftUI

private struct IconView: View {
    var state: ToastView.State
    var themeColor: Color
    
    var body: some View {
        switch state {
        case .info(_:):
            Symbol.info.image
            
        case .failure(_:):
            Symbol.xmarkCircle.image
            
        case .success(_:):
            Symbol.success.image
            
        case .loading(_:):
            ProgressView()
                .tint(themeColor)
        }
    }
}

private struct CloseButton: View {
    var state: ToastView.State
    var onDismiss: @MainActor () -> Void
    
    var body: some View {
        switch state {
        case .info(_:), .failure(_:), .success(_:):
            Button(.x, role: .close, action: onDismiss)
                .buttonStyle(.glass)
            
        default:
            EmptyView()
        }
    }
}

struct ToastView: View {
    var state: State
    var onDismiss: @MainActor () -> Void
    
    @ScaledMetric private var spacing = Layout.Spacing.small
    
    private var caption: String {
        switch state {
        case .failure(let error):
            return error.description
        
        case .info(let text), .success(let text), .loading(let text):
            return text
        }
    }
    private var themeColor: Color {
        switch state {
        case .info(_:):
            return .blue
            
        case .failure(_:):
            return .red
            
        case .success(_:):
            return .green
            
        case .loading(_:):
            return .secondary
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            IconView(state: state, themeColor: themeColor)
                .imageScale(.medium)
                .foregroundStyle(themeColor)
            
            Text(caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(5)
                
            CloseButton(state: state, onDismiss: onDismiss)
        }
        .frame(minHeight: 45)
        .font(.callout)
        .fontWeight(.medium)
        .scale(.padding(.vertical), 10)
        .scale(.padding(.horizontal), 15)
        .foregroundStyle(Color.appForeground)
        .glassEffect(
            .regular.tint(themeColor.opacity(0.15)),
            in: RoundedRectangle(cornerRadius: .medium)
        )
    }
}

extension ToastView {
    enum State: Equatable {
        case info(String)
        case failure(CustomError)
        case success(String)
        case loading(String = .processing)
    }
    
    enum Duration {
        case indefinite
        case timed(Double)
    }
}

extension ToastView.State {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case
            (.info(let val1), .info(let val2)),
            (.success(let val1), .success(let val2)),
            (.loading(let val1), .loading(let val2)):
            return val1 == val2
            
        case (.failure(let val1), .failure(let val2)):
            return val1 == val2
        
        default:
            return false
        }
    }
}

#Preview {
    VStack {
        ToastView(state: .info("This is a sample toast")) {}
        ToastView(state: .failure(CustomError.network(.authError))) {}
        ToastView(state: .success("Successful request.")) {}
        ToastView(state: .loading("Parsing recipe...")) {}
    }
    .padding(20)
}
