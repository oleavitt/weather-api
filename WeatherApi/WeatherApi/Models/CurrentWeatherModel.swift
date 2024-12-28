//
//  CurrentWeatherModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import Foundation

struct CurrentWeatherModel: Identifiable, Hashable {
    var id: Int { epochUpdated }
    let location: String
    let epochUpdated: Int
    let dateTime: Date
    let tempC: Double
    let tempF: Double
    let icon: String
    let isDay: Bool
}
