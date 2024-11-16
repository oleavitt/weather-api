//
//  CurrentViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

class CurrentViewModel: ObservableObject {
    
    @Published var state: LoadingState<ApiCurrent> = .empty
    
    var locationQuery = "Dallas"
    var showAirQuality = false
    var showFahrenheit = true
    var showImperial = true

    let networkLayer: NetworkLayer
    
    private var lastUpdated: Date?
    
    public init(_ networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
        print("Init")
    }

    deinit {
        print("Deinit")
    }
    
    private var apiCurrent: ApiCurrent?
    
    @MainActor
    func getCurrentWeather() async {
        if case LoadingState<ApiCurrent>.loading = state { return }
        if let lastUpdated {
            let timeElapsed = abs(lastUpdated.timeIntervalSinceNow)
            print("Time since last update: \(timeElapsed)")
            if timeElapsed < 60 {
                return
            }
        }
        
        guard let request = Endpoint.current(query: locationQuery,
                                             aqi: showAirQuality).request else {
            return
        }

        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: ApiCurrent.self)
            apiCurrent = current
            lastUpdated = Date.now
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
    
    var tempString: String {
        if let temp = showFahrenheit ? apiCurrent?.current?.tempF : apiCurrent?.current?.tempC {
            return temp.formatted() + "°"
        }
        return "--"
    }
    
    var tempUnits: String {
        String(localized: showFahrenheit ? "deg_f" : "deg_c")
    }
    
    var locationName: String {
        if let city = apiCurrent?.location?.name {
            var locationName = city
            if let state = apiCurrent?.location?.region {
                locationName += ", " + state
            }
            return locationName
        }
        return "--"
    }
    
    var condition: String {
        apiCurrent?.current?.condition.text ?? "--"
    }
    
    var feelsLike: String {
        if let temp = showFahrenheit ? apiCurrent?.current?.feelslikeF : apiCurrent?.current?.feelslikeC {
            return String(localized: "feels_like \(temp.formatted())")
        }
        return "--"
    }
    
    var windDir: String {
        apiCurrent?.current?.windDir ?? "--"
    }
    
    var windSpeed: String {
        (showImperial ? apiCurrent?.current?.windMph : apiCurrent?.current?.windKph)?.formatted() ?? "--"
    }
    
    var gustSpeed: String {
        (showImperial ? apiCurrent?.current?.gustMph : apiCurrent?.current?.gustKph)?.formatted() ?? "--"
    }
    
    var speedUnits: String {
        String(localized: showImperial ? "mph" : "kph")
    }
    
    var windSummary: String {
        String(localized: "Wind \(windDir) \(windSpeed) \(speedUnits), gusts \(gustSpeed) \(speedUnits)")
    }
    
    var isDay: Bool {
        (apiCurrent?.current?.isDay ?? 0) > 0
    }
}
