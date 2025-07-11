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
            
        case .error(_:):
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
        case .info(_:), .error(_:), .success(_:):
            Button(action: onDismiss) {
                Symbol.x.image
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.appForeground.opacity(0.75))
                    .imageScale(.medium)
            }
            
        default:
            EmptyView()
        }
    }
}

struct ToastView: View {
    var state: State
    var onDismiss: @MainActor () -> Void
    
    @ScaledMetric private var spacing: CGFloat = 10
    
    private var caption: String {
        switch state {
        case .error(let error):
            return error.description
        
        case .info(let text), .success(let text), .loading(let text):
            return text
        }
    }
    private var themeColor: Color {
        switch state {
        case .info(_:):
            return .blue
            
        case .error(_:):
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
        .font(.caption)
        .fontWeight(.medium)
        .scale(.padding(.vertical), 10)
        .scale(.padding(.horizontal), 15)
        .foregroundStyle(Color.appForeground)
        .background(Color.appBackground)
        .rounded(cornerRadius: .regular, lineWidth: 1, color: themeColor)
        .shadow()
    }
}

extension ToastView {
    enum State: Equatable {
        case info(String)
        case error(CustomError)
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
            
        case (.error(let val1), .error(let val2)):
            return val1 == val2
        
        default:
            return false
        }
    }
}

#Preview {
    VStack {
        ToastView(state: .info("This is a sample toast")) {}
        ToastView(state: .error(CustomError.network(.authError))) {}
        ToastView(state: .success("Successful request.")) {}
        ToastView(state: .loading("Parsing recipe...")) {}
    }
    .padding(20)
}
