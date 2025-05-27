//
//  CustomLabelStyle.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 27/5/2025.
//

import SwiftUI

struct CustomLabelStyle: LabelStyle {
    enum Kind {
        case verticalIconTitle(Font = .body, Image.Scale = .medium)
        case verticalTitleIcon(Font = .body, Image.Scale = .medium)
        case titleIcon(Font = .body, Image.Scale = .medium)
        case iconTitle(Font = .body, Image.Scale = .medium)
    }
    
    var kind: Kind = .iconTitle()
    
    func makeBody(configuration: Configuration) -> some View {
        switch kind {
        case let .verticalIconTitle(font, scale):
            VStack(alignment: .center, spacing: 8) {
                configuration.icon
                    .imageScale(scale)
                configuration.title
            }
            .font(font)
        
        case let .verticalTitleIcon(font, scale):
            VStack(alignment: .center, spacing: 8) {
                configuration.title
                configuration.icon
                    .imageScale(scale)
            }
            .font(font)
            
        case let .titleIcon(font, scale):
            HStack(alignment: .center, spacing: 8) {
                configuration.title
                configuration.icon
                    .imageScale(scale)
            }
            .font(font)
            
        case let .iconTitle(font, scale):
            HStack(alignment: .center, spacing: 8) {
                configuration.icon
                    .imageScale(scale)
                configuration.title
            }
            .font(font)
        }
    }
}

extension CustomLabelStyle {
    init(_ kind: Kind) {
        self.init(kind: kind)
    }
}

#Preview {
    Label("Add Item", symbol: .plus)
        .labelStyle(
            CustomLabelStyle(.titleIcon(.headline, .small))
        )
}
