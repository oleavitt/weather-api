//
//  AlertLevel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 4/6/25.
//

import SwiftUI

enum AlertLevel: String {
    case minor, moderate, severe

    var color: Color {
        switch self {
        case .minor: return Color("alert-minor")
        case .moderate: return Color("alert-moderate")
        case .severe: return Color("alert-severe")
        }
    }
}
