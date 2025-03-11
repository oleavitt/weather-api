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
    let highTemp: Double
    let lowTemp: Double
    let conditionIconURL: URL?
    let condition: String
    let chanceOfPrecip: Int
    let chanceOfSnow: Int
    let hours: [ForecastHour]

    /// Voice over label for forecast day
    var a11yLabel: String {
        (date ?? .now).formatted(date: .abbreviated, time: .omitted)
    }

    /// Voice over summary of forecast day
    var a11yDaySummary: String {
        if chanceOfSnow > 0 {
            // swiftlint:disable:next line_length
            return String(localized: "\(condition), high \(highTemp.formatted())°, low \(lowTemp.formatted())°, rain \(chanceOfPrecip)% snow \(chanceOfSnow)%")
        } else {
            // swiftlint:disable:next line_length
            return String(localized: "\(condition), high \(highTemp.formatted())°, low \(lowTemp.formatted())°, rain \(chanceOfPrecip)%")
        }
    }
}

/// For the hours views.
struct ForecastHour: Identifiable, Hashable {
    var id: Int { epoch }
    let epoch: Int
    let time: Date?
    let temp: Double
    let conditionIconURL: URL?
    let condition: String
    let chanceOfPrecip: Int
    var sunRiseSetImage: String?
    var isSunset = false

    var isSunRiseSet: Bool {
        sunRiseSetImage?.isEmpty == false
    }

    private let hourFormatter = DateFormatter()

    var displayTime: String {
        if isSunRiseSet {
            hourFormatter.dateFormat = "h:mma"
        } else {
            hourFormatter.dateFormat = "ha"
        }
        return hourFormatter.string(from: time ?? .now)
    }

    /// Voice over label for forecast hour
    var a11yLabel: String {
        if isSunset {
            return String(localized: "sunset")
        } else if !(sunRiseSetImage?.isEmpty ?? true) {
            return String(localized: "sunrise")
        }
        return displayTime
    }

    /// Voice over summary of forecast hour
    var a11yHourSummary: String {
        if isSunRiseSet {
            return displayTime
        }
        return "\(temp.formatted())°, \(condition)"
    }
}
