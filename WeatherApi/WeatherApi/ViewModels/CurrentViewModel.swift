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
        URL.httpsURL(apiModel?.current?.condition.icon)
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
    
    func forecastDays() -> [ForcastDayViewModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let riseSetInputFormatter = DateFormatter()
        riseSetInputFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "ha"
        let hourMinFormatter = DateFormatter()
        hourMinFormatter.dateFormat = "h:mma"

        return apiModel?.forecast?.forecastday.map {
            let date = dateFormatter.date(from: $0.date)
            let maxTemp: Double
            let minTemp: Double
            if showFahrenheit {
                maxTemp = $0.day.maxtempF
                minTemp = $0.day.mintempF
            } else {
                maxTemp = $0.day.maxtempC
                minTemp = $0.day.mintempC
            }
            var hours: [ForecastHour] = $0.hour.map {
                let timeString: String
                if let time = dateTimeFormatter.date(from: $0.time ?? "") {
                    timeString = hourFormatter.string(from: time)
                } else {
                    timeString = "--"
                }
                let temp: Double
                if showFahrenheit {
                    temp = $0.tempF
                } else {
                    temp = $0.tempC
                }
                return ForecastHour(epoch: $0.timeEpoch ?? 0,
                                    time: timeString,
                                    temp: temp,
                                    conditionIconURL: URL.httpsURL($0.condition.icon))
            }
            if let sunriseTime = riseSetInputFormatter.date(from: "\($0.date) \($0.astro.sunrise)") {
                let sunrise = ForecastHour(epoch: Int(sunriseTime.timeIntervalSince1970),
                                           time: hourMinFormatter.string(from: sunriseTime),
                                           temp: 0.0,
                                           conditionIconURL: nil,
                                           sunRiseSetImage: "sunrise.fill",
                                           isSunset: false)
                hours.append(sunrise)
            }
            if let sunsetTime = riseSetInputFormatter.date(from: "\($0.date) \($0.astro.sunset)") {
                let sunset = ForecastHour(epoch: Int(sunsetTime.timeIntervalSince1970),
                                          time: hourMinFormatter.string(from: sunsetTime),
                                          temp: 0.0,
                                          conditionIconURL: nil,
                                          sunRiseSetImage: "sunset.fill",
                                          isSunset: true)
                hours.append(sunset)
            }
            hours = hours.sorted {
                $0.epoch < $1.epoch
            }
            return ForcastDayViewModel(epoch: $0.dateEpoch,
                                       date: date,
                                       hi: maxTemp,
                                       lo: minTemp,
                                       conditionIconURL: URL.httpsURL($0.day.condition.icon),
                                       hours: hours)
        } ?? []
    }
}
