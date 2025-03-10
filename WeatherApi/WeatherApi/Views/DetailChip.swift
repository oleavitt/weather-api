//
//  DetailChip.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/29/24.
//

import SwiftUI

struct DetailChip: View {
    var title: LocalizedStringKey
    var value: String
    var a11yLabel: LocalizedStringKey
    
    init(_ title: LocalizedStringKey, _ value: String, a11yLabel: LocalizedStringKey) {
        self.title = title
        self.value = value
        self.a11yLabel = a11yLabel
    }
    
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

#Preview {
    DetailChip("Title", "Value", a11yLabel: "Title value")
}
