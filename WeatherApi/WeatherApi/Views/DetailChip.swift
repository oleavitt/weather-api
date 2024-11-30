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
    
    init(_ title: LocalizedStringKey, _ value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 12))
            Text(value)
        }
        .frame(minHeight: 50)
        .padding(.horizontal)
        .background {
            currentTheme.backgroundColor
        }
        .cornerRadius(16)
        .font(.custom(
            currentTheme.fontFamily, fixedSize: 14))
        .foregroundStyle(.secondary)
        .foregroundColor(.primary)
    }
}

#Preview {
    DetailChip("Title", "Value")
}
