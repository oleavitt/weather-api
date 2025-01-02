//
//  CurrentWeatherModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import Foundation
import SwiftData

@Model
final class CurrentWeatherModel: Identifiable, Hashable {
    var id: Int { epochUpdated }
    var location: String
    var epochUpdated: Int
    var dateTime: Date
    var tempC: Double
    var tempF: Double
    var icon: String
    var code: Int
    var uv: Double
    var isDay: Bool
    
    init(location: String,
         epochUpdated: Int,
         dateTime: Date,
         tempC: Double,
         tempF: Double,
         icon: String,
         code: Int,
         uv: Double,
         isDay: Bool) {
        self.location = location
        self.epochUpdated = epochUpdated
        self.dateTime = dateTime
        self.tempC = tempC
        self.tempF = tempF
        self.icon = icon
        self.code = code
        self.uv = uv
        self.isDay = isDay
    }
}

typealias CurrentWeatherHistory = [CurrentWeatherModel]



