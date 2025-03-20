//
//  CurrentWeatherModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import Foundation
import SwiftData

// swiftlint:disable identifier_name

/// The Core Data model object used in the History view list
@Model
final class CurrentWeatherModel {
    @Attribute(.unique) var id: UUID
    var location: String
    var dateTime: Date
    var tempC: Double
    var tempF: Double
    var icon: String
    var condition: String
    var code: Int
    var uv: Double
    var isDay: Bool

    init(location: String,
         dateTime: Date,
         tempC: Double,
         tempF: Double,
         icon: String,
         condition: String,
         code: Int,
         uv: Double,
         isDay: Bool) {
        id = UUID()
        self.location = location
        self.dateTime = dateTime
        self.tempC = tempC
        self.tempF = tempF
        self.icon = icon
        self.condition = condition
        self.code = code
        self.uv = uv
        self.isDay = isDay
    }
}
// swiftlint:enable identifier_name
