//
//  CardStyle.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

/// A style with rouded corners and theme background color for card style views..
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
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
