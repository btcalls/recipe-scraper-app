//
//  Layout.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 18/12/2025.
//

import Foundation
import SwiftUI

/// A central place for layout constants to keep spacing and sizing consistent.
///
/// Usage examples:
/// - `.padding(.horizontal, Layout.Padding.horizontal)`
/// - `.cornerRadius(Layout.CornerRadius.medium)`
/// - `.frame(height: Layout.Size.rowHeight)`
/// - `@ScaledMetric var spacing = Layout.Scaled.spacing`
public enum Layout {
    public struct CornerRadius: Hashable, Sendable {
        public let rawValue: CGFloat
        
        public init(_ rawValue: CGFloat) {
            self.rawValue = rawValue
        }
        
        // Presets
        public static let small = CornerRadius(8)
        public static let medium = CornerRadius(16)
        public static let large = CornerRadius(24)
    }

    public struct AspectRatio: Hashable, Sendable {
        public let rawValue: CGFloat
        
        public init(_ rawValue: CGFloat) {
            self.rawValue = rawValue
        }
        
        // Common presets
        public static let square = AspectRatio(1)
        public static let golden = AspectRatio(1.618)
        public static let photo16x9 = AspectRatio(16.0/9.0)
        public static let photo4x3 = AspectRatio(4.0/3.0)
    }

    // MARK: - Spacing
    
    public enum Spacing {
        public static let xSmall: CGFloat = 4
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let xLarge: CGFloat = 24
        public static let xxLarge: CGFloat = 32
    }

    // MARK: - Padding shortcuts
    
    public enum Padding {
        /// Standard horizontal padding for content containers.
        public static let horizontal: CGFloat = Spacing.large
        /// Standard vertical padding for content containers.
        public static let vertical: CGFloat = Spacing.medium
        /// Compact padding for tighter groups.
        public static let compact: CGFloat = Spacing.small
        /// Comfortable padding for larger touch targets.
        public static let comfortable: CGFloat = Spacing.xLarge
    }

    // MARK: - Sizes / Heights
    
    public enum Size {
        /// Standard row height for list-like rows.
        public static let rowHeight: CGFloat = 56
        /// Minimum tappable size for buttons (Apple HIG ~44pt).
        public static let minTap: CGFloat = 44
        /// Thumbnail dimension used for small images.
        public static let thumbnail: CGFloat = 48
        /// Card corner content insets.
        public static let cardInset: CGFloat = Padding.comfortable
    }

    // MARK: - Scaled metrics (Dynamic Type aware defaults)
    
    /// Provides defaults that work nicely with `@ScaledMetric`.
    public enum Scaled {
        /// Default spacing for vertical stacks.
        public static let spacing: CGFloat = Spacing.large
        /// Default inter-item spacing in grid/list items.
        public static let interItem: CGFloat = Spacing.medium
        /// Default corner radius for scalable surfaces.
        public static let cornerRadius: CornerRadius = .medium
    }
}
