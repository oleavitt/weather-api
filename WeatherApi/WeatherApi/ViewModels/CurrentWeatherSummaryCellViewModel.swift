//
//  CurrentWeatherSummaryCellViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import SwiftUI

/// A view model interface for the current summary and history cell views.
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
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: data.dateTime)
    }

    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.amSymbol = String(localized: "am")
        timeFormatter.pmSymbol = String(localized: "pm")
        return timeFormatter.string(from: data.dateTime)
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

    var a11yCurrentWeatherSummary: String {
        // swiftlint:disable:next line_length
        String(localized: "\(data.location), \(data.dateTime.formatted(date: .abbreviated, time: .shortened)), \(temperature), \(data.condition)")
    }
}
