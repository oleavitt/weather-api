//
//  WindViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

class WindViewModel: ObservableObject {
    @AppStorage(AppSettings.unitsSpeed.rawValue) private var speedUnitsSetting: SpeedUnits = .mph
    @Published var windModel: WindModel?
    
    init(windModel: WindModel?) {
        self.windModel = windModel
    }
    
    var speedUnits: String {
        speedUnitsSetting.symbol
    }

    var speed: String {
        ((speedUnitsSetting == .mph) ? windModel?.speedMph : windModel?.speedKph)?.formatted() ?? "--"
    }
    
    var windSummary: String {
        String(localized: "speed \(speed) \(speedUnits)")
    }
    
    var direction: String {
        windModel?.direction ?? "--"
    }
    
    var directionSummary: String {
        String(localized: "direction \(direction)")
    }
    
    var gust: String {
        ((speedUnitsSetting == .mph) ? windModel?.gustMph : windModel?.gustKph)?.formatted() ?? "--"
    }
    
    var gustsSummary: String {
        String(localized: "gusts \(gust) \(speedUnits)")
    }
    
    var hasWind: Bool {
        let speedValue = windModel?.speedMph ?? 0.0
        return speedValue > 0.01
    }
    
    var hasGusts: Bool {
        let gustsValue = windModel?.gustMph ?? 0.0
        let speedValue = windModel?.speedMph ?? 0.0
        // Let's consider gusts if they are greater than speed by at least a half mile per hour
        return gustsValue > (speedValue + 0.5)
    }
    
    var a11yWindSummary: String {
        if hasWind {
            if hasGusts {
                return String(localized: "wind direction \(direction), speed \(speed) \(speedUnits) with gusts of \(gust) \(speedUnits)")
            }
            return String(localized: "wind direction \(direction), speed \(speed) \(speedUnits)")
        }
        return String(localized: "no wind")
    }
    
}
