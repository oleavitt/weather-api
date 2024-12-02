//
//  Theme.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/29/24.
//

import SwiftUI

var currentTheme = WeatherAppTheme.default

struct WeatherAppTheme {
    static let `default` = WeatherAppTheme(
        fontFamily: "Arial",
        backgroundColor: Color(white: 0.95),
        cornerRadius: 8
    )
    
    let fontFamily: String
    let backgroundColor: Color
    let cornerRadius: Double
}
