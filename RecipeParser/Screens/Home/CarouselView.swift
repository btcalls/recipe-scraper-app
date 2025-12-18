//
//  CarouselView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/7/2025.
//

import SwiftUI
import SwiftData

struct CarouselView: View {
    @ScaledMetric private var width: CGFloat = 150
    @ScaledMetric private var labelHeight: CGFloat = 75
    @ScaledMetric private var spacing: CGFloat = 10
    @State private var currentRecipe: Recipe?
    
    private var recipes: [Recipe] {
        let items = try? MockService.shared.getRecipes()
        
        return items ?? []
    }
    
    private var weekday: Text {
        return Text(Date.now.formatted(.dateTime.weekday(.wide)))
            .foregroundColor(.accentColor)
            .fontWeight(.bold)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text("Recipe for \(weekday) is...")
                .font(.title2)
                .fontWeight(.medium)
            
            ScrollViewReader { scrollProxy in
                GeometryReader { proxy in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: spacing) {
                            ForEach(recipes, id: \.id) { recipe in
                                VStack(alignment: .center, spacing: spacing) {
                                    CustomImage(kind: .url(recipe.imageURL, toCache: true))
                                        .frame(width: width, height: width)
                                        .clipTo(
                                            RoundedRectangle(
                                                cornerRadius: .small
                                            )
                                        )
                                        .scrollTransition { view, transition in
                                            view
                                                .opacity(transition.isIdentity ? 1 : 0.3)
                                                .scaleEffect(transition.isIdentity ? 1 : 0.75)
                                        }
                                        .shadow()
                                    
                                    Text(recipe.name)
                                        .frame(
                                            width: width,
                                            height: labelHeight,
                                            alignment: .top
                                        )
                                        .multilineTextAlignment(.center)
                                        .fontWeight(.medium)
                                        .scrollTransition { view, transition in
                                            view.opacity(transition.isIdentity ? 1 : 0)
                                        }
                                }
                                .id(recipe.name)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, (proxy.size.width - width) / 2)
                    .defaultScrollAnchor(.center)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                    .scrollIndicators(.hidden)
                }
                .onAppear {
                    // TODO: Query likely recipe based on current date
                    scrollProxy.scrollTo("Hamburger", anchor: .center)
                }
            }
        }
    }
}

#Preview {
    CarouselView()
}
