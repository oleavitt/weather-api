//
//  CurrentViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import SwiftUI

class CurrentViewModel: ObservableObject {
    
    @Published var state: LoadingState<ApiModel> = .empty
    
    var locationQuery = ""
    var showAirQuality = false
    var showFahrenheit = true
    var showImperial = true
    
    let networkLayer: NetworkLayer
    
    private var lastUpdated: Date?
    private var lastLocationQuery: String?
    
    public init(_ networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    private var apiModel: ApiModel?
    
    @MainActor
    func getCurrentAndForecastWeather() async {
        locationQuery = locationQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if locationQuery.isEmpty {
            state = .empty
            return
        }
        
        if case LoadingState<ApiModel>.loading = state { return }
        if let lastUpdated {
            let timeElapsed = abs(lastUpdated.timeIntervalSinceNow)
            print("Time since last update: \(timeElapsed)")
            if timeElapsed < 60 && lastLocationQuery == locationQuery {
                return
            }
        }
        
        guard let request = Endpoint.currentForecast(query: locationQuery,
                                             aqi: showAirQuality).request else {
            return
        }
        
        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: ApiModel.self)
            apiModel = current
            lastUpdated = Date.now
            lastLocationQuery = locationQuery
            if let errorResponse = current.error {
                state = .failure(ApiErrorType.fromErrorCode(code: errorResponse.code))
            } else {
                state = .success(current)
            }
        } catch {
            state = .failure(error)
            print(error)
        }
    }
}

extension CurrentViewModel {
    
    var conditionsIconUrl: URL? {
        guard let path = apiModel?.current?.condition.icon,
              var components = URLComponents(string: path) else {
            return nil
        }
        components.scheme = "https"
        return components.url
    }
    
    var tempString: String {
        if let temp = showFahrenheit ? apiModel?.current?.tempF : apiModel?.current?.tempC {
            return temp.formatted() + "°"
        }
        return "--"
    }
    
    var tempUnits: String {
        String(localized: showFahrenheit ? "deg_f" : "deg_c")
    }
    
    var locationName: String {
        if let city = apiModel?.location?.name {
            var locationName = city
            if let state = apiModel?.location?.region {
                locationName += ", " + state
            }
            return locationName
        }
        return "--"
    }
    
    var condition: String {
        apiModel?.current?.condition.text ?? "--"
    }
    
    var feelsLike: String {
        if let temp = showFahrenheit ? apiModel?.current?.feelslikeF : apiModel?.current?.feelslikeC {
            return String(localized: "feels_like \(temp.formatted())")
        }
        return "--"
    }
    
    var windDir: String {
        apiModel?.current?.windDir ?? "--"
    }
    
    var windSpeed: String {
        (showImperial ? apiModel?.current?.windMph : apiModel?.current?.windKph)?.formatted() ?? "--"
    }
    
    var gustSpeed: String {
        (showImperial ? apiModel?.current?.gustMph : apiModel?.current?.gustKph)?.formatted() ?? "--"
    }
    
    var speedUnits: String {
        String(localized: showImperial ? "mph" : "kph")
    }
    
    var windSummary: String {
        String(localized: "\(windDir) \(windSpeed) \(speedUnits)")
    }
    
    var gustsSummary: String {
        String(localized: "\(gustSpeed) \(speedUnits)")
    }
    
    var uvIndex: String {
        if let current = apiModel?.current {
            return String(localized: "\(current.uv.formatted())")
        }
        return "--"
    }

    var humidity: String {
        if let humidity = apiModel?.current?.humidity {
            return "\(humidity)%"
        }
        return "--%"
    }
    
    var isDay: Bool {
        (apiModel?.current?.isDay ?? 0) > 0
    }
}
