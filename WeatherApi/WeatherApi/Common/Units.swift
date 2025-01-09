//
//  Units.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import Foundation

/// Temperature units
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

/// Wind speed units
enum SpeedUnits: String, Codable, CaseIterable {
    case mph
    case kph
    
    var symbol: String {
        switch self {
        case .mph: return String(localized: "mph")
        case .kph: return String(localized: "kph")
        }
    }
    
    static var title: String {
        String(localized: "speed")
    }
    
    var description: String {
        switch self {
        case .mph: return String(localized: "description-mph")
        case .kph: return String(localized: "description-kph")
        }
    }
}

/// Barametric pressure units
enum PressureUnits: String, Codable, CaseIterable {
    case inches
    case milliBars
    
    var symbol: String {
        switch self {
        case .inches: return String(localized: "in")
        case .milliBars: return String(localized: "mb")
        }
    }
    
    static var title: String {
        String(localized: "pressure")
    }
    
    var description: String {
        switch self {
        case .inches: return String(localized: "description-inches")
        case .milliBars: return String(localized: "description-millibars")
        }
    }
}
