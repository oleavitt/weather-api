//
//  CurrentWeatherModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import Foundation
import SwiftData

@Model
final class CurrentWeatherModel {
    @Attribute(.unique) var id: UUID
    var location: String
    var dateTime: Date
    var tempC: Double
    var tempF: Double
    var icon: String
    var code: Int
    var uv: Double
    var isDay: Bool
    
    init(location: String,
         dateTime: Date,
         tempC: Double,
         tempF: Double,
         icon: String,
         code: Int,
         uv: Double,
         isDay: Bool) {
        id = UUID()
        self.location = location
        self.dateTime = dateTime
        self.tempC = tempC
        self.tempF = tempF
        self.icon = icon
        self.code = code
        self.uv = uv
        self.isDay = isDay
    }
}




