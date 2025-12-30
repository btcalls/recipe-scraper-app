//
//  BulletedList.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 29/12/2025.
//

import SwiftUI

struct BulletedList: View {
    @ScaledMetric private var spacing = Layout.Scaled.interItem
    
    var items: [String]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: spacing) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: spacing) {
                        Text("•")
                            .fontWeight(.bold)
                        
                        Text(item)
                            .fontWeight(.light)
                    }
                }
            }
        }
    }
}

#Preview {
    BulletedList(items: MockService.shared.getRecipe().instructions)
}
