//
//  WeatherDataSource.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/18/25.
//

import Foundation
import Combine

/// Abstract interface for fetching weather data from the actual source.
protocol WeatherDataSource {

    /// Perform any initial setup needed for this data source.
    /// - Parameters:
    ///   - networkLayer: The NetworkLayer to get raw data from.
    ///   - apiKey: Any needed API key string.
    func setup(
        networkLayer: NetworkLayer,
        apiKey: String
    )

    /// Get the weather forecast data from this data source.
    /// - Parameters:
    ///   - locationQuery: The location search query in formats used by this data source.
    ///   - includeAqi: Include air quality data.
    ///   - completion: Completion handler to receive successful data or Error result.
    func getForecast(
        locationQuery: String,
        includeAqi: Bool,
        completion: @escaping (Result<WeatherData, Error>) -> Void
    )

    /// Date and time of last update on data source end.
    var dateTimeLastUpdated: Date? { get }

    /// Location details for this weather report.
    var locationData: LocationData? { get }

    /// The current temperature in user's selected temperature units.
    func currentTemp(units: TempUnits) -> Double?
}
