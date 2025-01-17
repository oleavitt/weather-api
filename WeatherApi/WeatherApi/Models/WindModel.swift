//
//  WindModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import Foundation

struct WindModel {
    let speedKph: Double
    let speedMph: Double
    let degree: Double
    let direction: String
    let gustKph: Double
    let gustMph: Double
    
    init(speedKph: Double, speedMph: Double, degree: Double, direction: String, gustKph: Double, gustMph: Double) {
        self.speedKph = speedKph
        self.speedMph = speedMph
        self.degree = degree
        self.direction = direction
        self.gustKph = gustKph
        self.gustMph = gustMph
    }
}
