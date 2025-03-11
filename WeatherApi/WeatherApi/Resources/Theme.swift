//
//  Theme.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/29/24.
//

import SwiftUI

@MainActor var currentTheme = WeatherAppTheme.default

/// A shared collection of app theming constants.
struct WeatherAppTheme {
    static let `default` = WeatherAppTheme(
        fontFamily: "Arial",
        backgroundColor: .cellBackground,
        cornerRadius: 8
    )

    let fontFamily: String
    let backgroundColor: Color
    let cornerRadius: Double
}
