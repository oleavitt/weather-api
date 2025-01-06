//
//  CurrentWeatherSummaryCellViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import SwiftUI

class CurrentWeatherSummaryCellViewModel: ObservableObject {
    var data: CurrentWeatherModel

    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit

    init(data: CurrentWeatherModel) {
        self.data = data
    }
    
    var temperature: String {
        "\((tempUnitsSetting == .fahrenheit ? data.tempF : data.tempC).formatted())°"
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: data.dateTime)
    }
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"
        return timeFormatter.string(from: data.dateTime).lowercased()
    }

    var location: String {
        data.location
    }
    
    var isDay: Bool {
        data.isDay
    }
    
    var iconURL: URL? {
        URL.httpsURL(data.icon)
    }
}
