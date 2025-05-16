//
//  ToastView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 15/5/2025.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var state: State = .error(CustomError.network(.authError))
    var onDismiss: @MainActor () -> Void
    
    private var caption: String {
        switch state {
        case .error(let error):
            return error.description
        
        case .info(let text), .success(let text):
            return text
        }
    }
    private var icon: Image {
        switch state {
        case .info(_:):
            return Symbol.info.image
        
        case .error(_:):
            return Symbol.error.image

        case .success(_:):
            return Symbol.success.image
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
            return .secondary
            
        case .error(_:):
            return .red
            
        case .success(_:):
            return .green
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            icon
                .font(.system(size: 18))
            
            Text(caption)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            
            Spacer(minLength: 10)
            
            Button(action: onDismiss) {
                Symbol.x.image
                    .padding(10)
            }
        }
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
            (.success(let val1), .success(let val2)):
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
        ToastView(state: .success("Hello!")) {}
    }
    .padding(20)
}
