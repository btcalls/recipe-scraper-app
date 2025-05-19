//
//  ToastView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 15/5/2025.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var state: State
    var onDismiss: @MainActor () -> Void
    
    private var caption: String {
        switch state {
        case .error(let error):
            return error.description
        
        case .info(let text), .success(let text), .loading(let text):
            return text
        }
    }
    private var bgColor: Color {
        return colorScheme == .light ? .offWhite : .darkGray
    }
    private var textColor: Color {
        return colorScheme == .light ? .darkGray : .offWhite
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
    
    @ViewBuilder private var iconView: some View {
        switch state {
        case .info(_:):
            Symbol.info.image
            
        case .error(_:):
            Symbol.error.image
            
        case .success(_:):
            Symbol.success.image
            
        case .loading(_:):
            ProgressView()
        }
    }
    
    @ViewBuilder private var closeButton: some View {
        switch state {
        case .info(_:), .error(_:), .success(_:):
            Button(action: onDismiss) {
                Symbol.x.image
                    .padding(10)
            }
            
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            iconView
                .font(.system(size: 18))
            
            Text(caption)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            
            Spacer(minLength: 10)
                
            closeButton
        }
        .frame(minHeight: 30)
        .font(.caption)
        .foregroundColor(themeColor)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(bgColor)
        .rounded(lineWidth: 1, color: themeColor)
        .shadow(basedOn: colorScheme)
    }
}

extension ToastView {
    enum State: Equatable {
        case info(String)
        case error(CustomError)
        case success(String)
        case loading(String)
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
