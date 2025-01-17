//
//  CardStyle.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

/// A style for cards.
/// - Note: This style is used for cards in the app.
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.horizontal, .bottom])
            .background {
                currentTheme.backgroundColor
            }
            .cornerRadius(currentTheme.cornerRadius)
            .font(.custom(
                currentTheme.fontFamily, fixedSize: 14))
            .foregroundStyle(.secondary)
            .foregroundColor(.primary)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
