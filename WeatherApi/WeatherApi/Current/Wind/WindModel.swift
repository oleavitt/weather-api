//
//  WindModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import Foundation

/// A container to pass wind data with
struct WindModel {
    let speedKph: Double
    let speedMph: Double
    let degree: Double
    let direction: String
    let gustKph: Double
    let gustMph: Double
}
