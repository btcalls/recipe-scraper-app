//
//  BottomControlView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 28/6/2025.
//

import SwiftUI

struct BottomControlView<Content>: View where Content : View {
    var isVertical = false

    @ViewBuilder let content: Content
    
    @ScaledMetric private var spacing: CGFloat = 10
    
    private var layout: AnyLayout {
        return isVertical ?
            AnyLayout(VStackLayout(alignment: .center, spacing: spacing)) :
            AnyLayout(HStackLayout(alignment: .center, spacing: spacing))
    }
    
    var body: some View {
        layout {
            content
        }
        .scale(.padding(.all), 10)
        .background(.thinMaterial)
        .clipShape(.capsule)
        .shadow()
    }
}

#Preview {
    BottomControlView {
        Text("Hello, world!")
    }
}
