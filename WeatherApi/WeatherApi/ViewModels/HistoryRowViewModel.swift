//
//  HistoryRowViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/5/25.
//

import SwiftUI

/// A view model interface for the current summary and history cell views.
struct HistoryRowViewModel {
    private var data: HistoryItemModel

    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit

    /// Initialize a new instance of HistoryRowViewModel.
    /// - Parameter data: A populated HistoryItemModel from which this will get its data.
    init(data: HistoryItemModel) {
        self.data = data
    }

    /// The temperature in user's selected units.
    var temperature: String {
        "\((tempUnitsSetting == .fahrenheit ? data.tempF : data.tempC).formatted())°"
    }

    /// The date of this summary as a short format date string.
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: data.dateTime)
    }

    /// The time of this summary as a short format time string.
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.amSymbol = String(localized: "am")
        timeFormatter.pmSymbol = String(localized: "pm")
        return timeFormatter.string(from: data.dateTime)
    }

    /// Location of this weather summary.
    var location: String {
        data.location
    }

    /// Indicates whether this is in the day or night.
    var isDay: Bool {
        data.isDay
    }

    /// URL to where icon resource is located.
    var iconURL: URL? {
        URL.httpsURL(data.icon)
    }

    /// A summary read-off of all items in this view for Voice Over.
    var a11yHistoryRowSummary: String {
        // swiftlint:disable:next line_length
        String(localized: "\(data.location), \(data.dateTime.formatted(date: .abbreviated, time: .shortened)), \(temperature), \(data.condition)")
    }
}
