//
//  Units.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import Foundation

enum TempUnits: String, Codable, CaseIterable {
    case fahrenheit
    case celsius
    
    var symbol: String {
        switch self {
        case .fahrenheit: return String(localized: "deg_f")
        case .celsius: return String(localized: "deg_c")
        }
    }
    
    static var title: String {
        String(localized: "temperature")
    }
    
    var description: String {
        switch self {
        case .fahrenheit: return String(localized: "description-deg_f")
        case .celsius: return String(localized: "description-deg_c")
        }
    }
}
