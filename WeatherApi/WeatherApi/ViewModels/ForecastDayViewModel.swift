//
//  ForecastDayViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/1/24.
//

import Foundation

struct ForcastDayViewModel: Identifiable, Hashable {
    var id = UUID()
    let date: Date?
    let hi: Double
    let lo: Double
    let conditionIconURL: URL?
}
