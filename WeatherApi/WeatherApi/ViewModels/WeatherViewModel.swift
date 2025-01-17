//
//  WeatherViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import SwiftUI

/// View model for the WeatherView which represents the Current and Forecast tabs of the app.
class WeatherViewModel: ObservableObject {
    
    /// Network layer interface that is injected into view model at the time of creation.
    let networkLayer: NetworkLayer

    /// Location search query that is passed to the API.
    var locationQuery = ""
    
    /// Indicator set from view to indicate a search is active.
    var isSearchQuery = false
    
    /// Set true to include air quality (AQI) results in API response
    var showAirQuality = false

    @Published var state: LoadingState<ApiModel> = .startup
    @Published var isLoaded = false

    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit
    @AppStorage(AppSettings.unitsSpeed.rawValue) var speedUnitsSetting: SpeedUnits = .mph
    @AppStorage(AppSettings.unitsPressure.rawValue) var pressureUnitsSetting: PressureUnits = .inches

    private var lastUpdated: Date?
    private var lastLocationQuery: String?
    
    public init(_ networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    /// Top level data moded that received result of API call
    private var apiModel: ApiModel?
    
    /// Make a request to the combined current and forecast API endpoint and update view model state with result.
    @MainActor
    func getCurrentAndForecastWeather() async {
        isLoaded = false
        
        // Make sure we have our API key.
        if weatherApiKey.isEmpty {
            state = .failure(ApiErrorType.noApiKey)
            return
        }
        
        // Make sure we have the required query parameter to send to the API.
        locationQuery = locationQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if locationQuery.isEmpty {
            state = .empty
            return
        }
        
        // Return if we are already loading or refreshing.
        if case LoadingState<ApiModel>.loading = state { return }
        
        // Don't update/refresh too soon if location did not change.
        if let lastUpdated {
            let timeElapsed = abs(lastUpdated.timeIntervalSinceNow)
#if DEBUG
            print("Time since last update: \(timeElapsed)")
            print("Last query: \(lastLocationQuery ?? "--"), Query: \(locationQuery)")
#endif
            if timeElapsed < 60 && lastLocationQuery == locationQuery {
                return
            }
        }
        
        // Get the combined current and forecast API endpoint
        guard let request = Endpoint.currentForecast(apiKey: weatherApiKey,
                                                     query: locationQuery,
                                                     aqi: showAirQuality).request else {
            return
        }
        
        // Indicate that we are loading and awaiting response...
        state = .loading
        
        // Now we can fetch the weather data and update final state based on result.
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: ApiModel.self)
            apiModel = current
            lastUpdated = Date.now
            lastLocationQuery = locationQuery
            if let errorResponse = current.error {
                state = .failure(ApiErrorType.fromErrorCode(code: errorResponse.code))
            } else {
                state = .success(current)
                isLoaded = true
            }
        } catch {
            state = .failure(error)
#if DEBUG
            print(error)
#endif
        }
    }
}

/// Computed properties that format response data using user's preferred units settings.
extension WeatherViewModel {
    /// Return a full https URL to the icon resource from the relative path returned in the API response.
    var conditionsIconUrl: URL? {
        URL.httpsURL(apiModel?.current?.condition.icon)
    }
    
    var tempString: String {
        if let temp = (tempUnitsSetting == .fahrenheit) ? apiModel?.current?.tempF : apiModel?.current?.tempC {
            return temp.formatted() + "°"
        }
        return "--"
    }
    
    var tempUnits: String {
        tempUnitsSetting.symbol
    }
    
    var timeLastUpdated: String {
        apiModel?.current?.lastUpdated ?? "--"
    }
    
    var timeLastUpdatedDate: Date {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateTimeFormatter.date(from: timeLastUpdated) ?? Date()
    }
        
    var timeLastUpdatedFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.amSymbol = String(localized: "am")
        dateFormatter.pmSymbol = String(localized: "pm")
        return dateFormatter.string(from: timeLastUpdatedDate)
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
        if let temp = (tempUnitsSetting == .fahrenheit) ? apiModel?.current?.feelslikeF : apiModel?.current?.feelslikeC {
            return String(localized: "feels_like \(temp.formatted())")
        }
        return "--"
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
    
    var pressure: String {
        if let pressure = (pressureUnitsSetting == .inches) ? apiModel?.current?.pressureIn : apiModel?.current?.pressureMb {
            return "\(pressure.formatted()) \(pressureUnitsSetting.symbol)"
        }
        return "--"
    }
    
    var isDay: Bool {
        (apiModel?.current?.isDay ?? 0) > 0
    }
    
    var windModel: WindModel? {
        WindModel(speedKph: apiModel?.current?.windKph ?? 0.0,
                  speedMph: apiModel?.current?.windMph ?? 0.0,
                  degree: Double(apiModel?.current?.windDegree ?? 0),
                  direction: apiModel?.current?.windDir ?? "--",
                  gustKph: apiModel?.current?.gustKph ?? 0.0,
                  gustMph: apiModel?.current?.gustMph ?? 0.0)
    }
    
    /// Parse out the Forecast days/hours list from the response data
    /// - Returns: Array of forecast day structures for the forecast days list
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

        return apiModel?.forecast?.forecastDay.map { day in
            let date = dateFormatter.date(from: day.date)
            let maxTemp: Double
            let minTemp: Double
            if tempUnitsSetting == .fahrenheit {
                maxTemp = day.day.maxtempF
                minTemp = day.day.mintempF
            } else {
                maxTemp = day.day.maxtempC
                minTemp = day.day.mintempC
            }
            var hours: [ForecastHour] = day.hour.map { hour in
                let timeString: String
                if let time = dateTimeFormatter.date(from: hour.time) {
                    timeString = hourFormatter.string(from: time)
                } else {
                    timeString = "--"
                }
                let temp: Double
                if tempUnitsSetting == .fahrenheit {
                    temp = hour.tempF
                } else {
                    temp = hour.tempC
                }
                return ForecastHour(epoch: hour.timeEpoch,
                                    time: timeString,
                                    temp: temp,
                                    conditionIconURL: URL.httpsURL(hour.condition.icon),
                                    chanceOfPrecip: hour.chanceOfRain)
            }
            if let sunriseTime = riseSetInputFormatter.date(from: "\(day.date) \(day.astro.sunrise)") {
                let sunrise = ForecastHour(epoch: Int(sunriseTime.timeIntervalSince1970),
                                           time: hourMinFormatter.string(from: sunriseTime),
                                           temp: 0.0,
                                           conditionIconURL: nil,
                                           chanceOfPrecip: 0,
                                           sunRiseSetImage: "sunrise.fill",
                                           isSunset: false)
                hours.append(sunrise)
            }
            if let sunsetTime = riseSetInputFormatter.date(from: "\(day.date) \(day.astro.sunset)") {
                let sunset = ForecastHour(epoch: Int(sunsetTime.timeIntervalSince1970),
                                          time: hourMinFormatter.string(from: sunsetTime),
                                          temp: 0.0,
                                          conditionIconURL: nil,
                                          chanceOfPrecip: 0,
                                          sunRiseSetImage: "sunset.fill",
                                          isSunset: true)
                hours.append(sunset)
            }
            hours = hours.sorted {
                $0.epoch < $1.epoch
            }
            return ForcastDayViewModel(epoch: day.dateEpoch,
                                       date: date,
                                       hi: maxTemp,
                                       lo: minTemp,
                                       conditionIconURL: URL.httpsURL(day.day.condition.icon),
                                       condition: day.day.condition.text,
                                       chanceOfPrecip: day.day.dailyChanceOfRain,
                                       chanceOfSnow: day.day.dailyChanceOfSnow,
                                       hours: hours)
        } ?? []
    }
    
    /// Get a condensed version of current weather for the `CurrentWeatherSummaryCell` Forecast and History list
    /// - Returns: CurrentWeatherModel populated with data
    func currentWeatherModel() -> CurrentWeatherModel {
        CurrentWeatherModel(location: locationName,
                            epochUpdated: apiModel?.current?.lastUpdatedEpoch ?? 0,
                            dateTime: timeLastUpdatedDate,
                            tempC: apiModel?.current?.tempC ?? 0.0,
                            tempF: apiModel?.current?.tempF ?? 0.0,
                            icon: apiModel?.current?.condition.icon ?? "",
                            code: apiModel?.current?.condition.code ?? 0,
                            uv: apiModel?.current?.uv ?? 0.0,
                            isDay: isDay)
    }
}
