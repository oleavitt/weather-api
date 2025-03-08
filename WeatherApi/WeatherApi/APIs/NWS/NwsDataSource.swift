//
//  NwsDataSource.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/25/25.
//

import Foundation
import Combine

/// Implements a `WeatherDataSource` interface to get weather data from the National Weather Service API
/// See https://www.weather.gov/documentation/services-web-api
class NwsDataSource: WeatherDataSource {
    private let apiHost = "api.weatherapi.com"
    private var apiKey = "-"
    private var networkLayer: NetworkLayer?
    private var cancellable: AnyCancellable?
    private var apiModel: WeatherApiModel?

    func setup(networkLayer: any NetworkLayer, apiKey: String) {
        self.networkLayer = networkLayer
        // NWS does not require an API key
    }
    
    func getForecast(locationQuery: String, includeAqi: Bool, completion: @escaping (Result<WeatherData, any Error>) -> Void) {
        // TODO:
        completion(.failure(ApiErrorType.emptySearch))
    }
    
    var dateTimeLastUpdated: Date? {
        // TODO:
        return Date()
    }
    
    var locationData: LocationData? {
        // TODO:
        return nil
    }
    
    func currentTemp(units: TempUnits) -> Double? {
        // TODO:
        return nil
    }
    
}
