//
//  WindViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

/// The niew model for the WindView which provides user facing display and Voice Over strings.
final class WindViewModel: ObservableObject {
    @AppStorage(AppSettings.unitsSpeed.rawValue) private var speedUnitsSetting: SpeedUnits = .mph

    private var windModel: WindModel?

    /// Initialize a view model instance for the WindView.
    /// - Parameter windModel: Wind data to format and display.
    init(windModel: WindModel?) {
        self.windModel = windModel
    }

    /// Localized wind speed display string.
    var windSummary: String {
        String(localized: "speed \(speed) \(speedUnits)")
    }

    /// Localized wind direction display string.
    var directionSummary: String {
        String(localized: "direction \(degree) \(direction)")
    }

    /// Localized wind gusts display string.
    var gustsSummary: String {
        String(localized: "gusts \(gust) \(speedUnits)")
    }

    /// A summary read-off of all items in this view for Voice Over.
    var a11yWindSummary: String {
        if hasWind {
            if hasGusts {
                // swiftlint:disable:next line_length
                return String(localized: "wind direction \(degree) degrees \(direction), speed \(speed) \(speedUnits) with gusts of \(gust) \(speedUnits)")
            }
            return String(localized: "wind direction \(degree) degrees \(direction), speed \(speed) \(speedUnits)")
        }
        return String(localized: "no wind")
    }

}

// MARK: - Private

private extension WindViewModel {
    /// The speed units symbol string based on user's selected units.
    var speedUnits: String {
        speedUnitsSetting.symbol
    }

    /// Wind speed value as a formatted string in user's selected units.
    var speed: String {
        ((speedUnitsSetting == .mph) ? windModel?.speedMph : windModel?.speedKph)?.formatted() ?? "--"
    }

    /// Wind direction as a string if present or "--" if not.
    var direction: String {
        windModel?.direction ?? "--"
    }

    /// Wind direction angle in degrees as a string if present or "--" if not.
    var degree: String {
        windModel?.degree.rounded().formatted() ?? "--"
    }

    /// Gusts value as a formatted string in user's selected units.
    var gust: String {
        ((speedUnitsSetting == .mph) ? windModel?.gustMph : windModel?.gustKph)?.formatted() ?? "--"
    }

    /// Indicates if there is wind present (ignoring any tiny values).
    var hasWind: Bool {
        let speedValue = windModel?.speedMph ?? 0.0
        return speedValue > 0.01
    }

    /// Indicates if there are wind gusts (enough to be worth displaying).
    ///
    /// This will consider wind gusts if they are greater than base wind speed by at least a half mile per hour.
    var hasGusts: Bool {
        let gustsValue = windModel?.gustMph ?? 0.0
        let speedValue = windModel?.speedMph ?? 0.0
        return gustsValue > (speedValue + 0.5)
    }
}
