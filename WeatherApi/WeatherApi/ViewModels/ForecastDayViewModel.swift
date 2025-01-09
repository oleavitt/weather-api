//
//  ForecastDayViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/1/24.
//

import Foundation

/// A view model interface for the forecast days/hours views.
struct ForcastDayViewModel: Identifiable, Hashable {
    var id: Int { epoch }
    let epoch: Int
    let date: Date?
    let hi: Double
    let lo: Double
    let conditionIconURL: URL?
    let condition: String
    let chanceOfPrecip: Int
    let chanceOfSnow: Int
    let hours: [ForecastHour]
}

/// For the hours views.
struct ForecastHour: Identifiable, Hashable {
    var id: Int { epoch }
    let epoch: Int
    let time: String
    let temp: Double
    let conditionIconURL: URL?
    let chanceOfPrecip: Int
    var sunRiseSetImage: String?
    var isSunset = false
}
