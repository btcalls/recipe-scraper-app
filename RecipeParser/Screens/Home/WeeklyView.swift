//
//  WeeklyView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 21/7/2025.
//

import SwiftUI

struct WeeklyView: View {
    let header: String = .weeklyRecipes
    
    @ScaledMetric private var spacing: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(header)
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach(1..<7, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.appBackground)
                            .frame(width: 200, height: 250)
                            .rounded(cornerRadius: .regular)
                            .shadow()
                    }
                }
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    WeeklyView()
}
