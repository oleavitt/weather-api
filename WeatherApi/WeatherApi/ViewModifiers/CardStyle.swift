//
//  CardStyle.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

/// A style with rouded corners and theme background color for card style views..
private struct CardStyle: ViewModifier {
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
            .overlay {
                RoundedRectangle(cornerRadius: currentTheme.cornerRadius)
                    .stroke(currentTheme.borderColor, lineWidth: 1)
            }
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
