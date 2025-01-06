//
//  AppSettings.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import Foundation

/// The keys used for accessing settings stored in @AppStorage
enum AppSettings: String {
    case weatherApiKey = "weather-api-key"
    case unitsTemp = "units-temperature"
    case unitsSpeed = "units-speed"
}
