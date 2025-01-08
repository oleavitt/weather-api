//
//  ForecastDayViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/1/24.
//

import Foundation

struct ForcastDayViewModel: Identifiable, Hashable {
    var id: Int { epoch }
    let epoch: Int
    let date: Date?
    let hi: Double
    let lo: Double
    let conditionIconURL: URL?
    let condition: String
    let hours: [ForecastHour]
}

struct ForecastHour: Identifiable, Hashable {
    var id: Int { epoch }
    let epoch: Int
    let time: String
    let temp: Double
    let conditionIconURL: URL?
    var sunRiseSetImage: String?
    var isSunset = false
}
