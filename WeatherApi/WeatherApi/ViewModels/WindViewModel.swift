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
        String(localized: "speed \(direction) \(speed) \(speedUnits)")
    }
    
    var direction: String {
        windModel?.direction ?? "--"
    }
    
    var gust: String {
        ((speedUnitsSetting == .mph) ? windModel?.gustMph : windModel?.gustKph)?.formatted() ?? "--"
    }
    
    var gustsSummary: String {
        String(localized: "gusts \(gust) \(speedUnits)")
    }
}
