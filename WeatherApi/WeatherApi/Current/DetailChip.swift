//
//  DetailChip.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/29/24.
//

import SwiftUI

/// Displays a simple title/value in view with rounded corners as set by the cardStyle view modifier.
struct DetailChip: View {
    /// Creates a Detail chip.
    /// - Parameters:
    ///   - title: The title.
    ///   - value: The details or value.
    ///   - a11yLabel: Text for Voice Over read back.
    init(_ title: LocalizedStringKey, _ value: String, a11yLabel: LocalizedStringKey) {
        self.title = title
        self.value = value
        self.a11yLabel = a11yLabel
    }

    private var title: LocalizedStringKey
    private var value: String
    private var a11yLabel: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 14))
            Text(value)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 16))
                .foregroundStyle(.primary)
        }
        .frame(minHeight: 30)
        .cardStyle()
        .accessibilityElement()
        .accessibilityLabel(a11yLabel)
    }
}

// MARK: - Preview

#Preview {
    DetailChip("Title", "Value", a11yLabel: "Title value")
}
