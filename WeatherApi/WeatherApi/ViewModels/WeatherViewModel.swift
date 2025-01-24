//
//  WeatherViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import SwiftUI

// MARK: WeatherViewModel

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

    /// Weather data source interface
    var weatherDataSource: WeatherDataSource = WeatherApiComDataSource()
    
    @Published var state: LoadingState = .startup
    @Published var isLoaded = false

    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit
    @AppStorage(AppSettings.unitsSpeed.rawValue) var speedUnitsSetting: SpeedUnits = .mph
    @AppStorage(AppSettings.unitsPressure.rawValue) var pressureUnitsSetting: PressureUnits = .inches

    private var lastUpdated: Date?
    private var lastLocationQuery: String?
    private var error: Error?
    private let hourFormatter = DateFormatter()
    private let hourMinFormatter = DateFormatter()

    public init(_ networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    /// Top level data returned from the data source after fetching data
    private var weatherData: WeatherData?
    
    /// Make a request to the combined current and forecast API endpoint and update view model state with result.
    func getCurrentAndForecastWeather() {
        isLoaded = false
        error = nil
        
        // Make sure we have our API key.
        if weatherApiKey.isEmpty {
            state = .failure
            return
        }
        
        // Make sure we have the required query parameter to send to the API.
        locationQuery = locationQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if locationQuery.isEmpty {
            state = .empty
            return
        }
        
        // Return if we are already loading or refreshing.
        if state == .loading { return }
        
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
        
        // Indicate that we are loading and awaiting response...
        state = .loading

        // Prepare the data source
        weatherDataSource.setup(networkLayer: networkLayer, apiKey: weatherApiKey)

        // Now we can fetch the weather data and update final state based on result.
        weatherDataSource.getForecast(locationQuery: locationQuery,
                                                    includeAqi: showAirQuality, completion: { [weak self] result in
            self?.handleForcastCompletion(result: result)
        })
    }
}

// MARK: Properties for views

/// Computed properties that format response data using user's preferred units settings.
extension WeatherViewModel {
    /// Return a full https URL to the icon resource from the relative path returned in the API response.
    var conditionsIconUrl: URL? {
        URL.httpsURL(weatherData?.current?.condition.icon)
    }
    
    var tempString: String {
        if let temp = (tempUnitsSetting == .fahrenheit) ? weatherData?.current?.tempF : weatherData?.current?.tempC {
            return temp.formatted() + "°"
        }
        return "--"
    }
    
    var tempUnits: String {
        tempUnitsSetting.symbol
    }
    
    var timeLastUpdatedDate: Date {
        return weatherData?.current?.dateTimeLastUpdated ?? Date()
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
        if let city = weatherData?.location?.name {
            var locationName = city
            if let state = weatherData?.location?.region {
                locationName += ", " + state
            }
            return locationName
        }
        return "--"
    }
    
    var condition: String {
        weatherData?.current?.condition.text ?? "--"
    }
    
    var feelsLike: String {
        if let temp = (tempUnitsSetting == .fahrenheit) ? weatherData?.current?.feelslikeF : weatherData?.current?.feelslikeC {
            return String(localized: "feels_like \(temp.formatted())")
        }
        return "--"
    }
    
    var uvIndex: String {
        if let current = weatherData?.current {
            return String(localized: "\(current.uv.formatted())")
        }
        return "--"
    }

    var humidity: String {
        if let humidity = weatherData?.current?.humidity {
            return "\(humidity)%"
        }
        return "--%"
    }
    
    var pressure: String {
        if let pressure = (pressureUnitsSetting == .inches) ? weatherData?.current?.pressureIn : weatherData?.current?.pressureMb {
            return "\(pressure.formatted()) \(pressureUnitsSetting.symbol)"
        }
        return "--"
    }
    
    var isDay: Bool {
        (weatherData?.current?.isDay ?? 0) > 0
    }
    
    var windModel: WindModel? {
        WindModel(speedKph: weatherData?.current?.windKph ?? 0.0,
                  speedMph: weatherData?.current?.windMph ?? 0.0,
                  degree: Double(weatherData?.current?.windDegree ?? 0),
                  direction: weatherData?.current?.windDir ?? "--",
                  gustKph: weatherData?.current?.gustKph ?? 0.0,
                  gustMph: weatherData?.current?.gustMph ?? 0.0)
    }

    /// Parse out the Forecast days/hours list from the response data
    /// - Returns: Array of forecast day structures for the forecast days list
    func forecastDays() -> [ForcastDayViewModel] {
        hourFormatter.dateFormat = "ha"
        hourMinFormatter.dateFormat = "h:mma"

        return weatherData?.forecast?.forecastDays.map { forecastDay in
            let maxTemp: Double
            let minTemp: Double
            if tempUnitsSetting == .fahrenheit {
                maxTemp = forecastDay.day.maxtempF
                minTemp = forecastDay.day.mintempF
            } else {
                maxTemp = forecastDay.day.maxtempC
                minTemp = forecastDay.day.mintempC
            }
            
            
            return ForcastDayViewModel(epoch: forecastDay.dateEpoch,
                                       date: forecastDay.date,
                                       hi: maxTemp,
                                       lo: minTemp,
                                       conditionIconURL: URL.httpsURL(forecastDay.day.condition.icon),
                                       condition: forecastDay.day.condition.text,
                                       chanceOfPrecip: forecastDay.day.dailyChanceOfRain,
                                       chanceOfSnow: forecastDay.day.dailyChanceOfSnow,
                                       hours: forecastHours(forecastDay: forecastDay))
        } ?? []
    }
    
    /// Parse out the hours list for the given day from the response data ans insert the sunrise/set times if theye are there
    /// - Parameter forecastDay: The forecast day
    /// - Returns: The hours list including sunrise and sunset times
    private func forecastHours(forecastDay: ForecastDayData) -> [ForecastHour] {
        // Build the 24 hour list
        var hoursList: [ForecastHour] = forecastDay.forecastHours.map { hour in
            let timeString: String
            if let time = hour.time {
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
        
        // Insert the sunrise and sunset times
        if let sunriseTime = forecastDay.astro.sunrise {
            let sunrise = ForecastHour(epoch: Int(sunriseTime.timeIntervalSince1970),
                                       time: hourMinFormatter.string(from: sunriseTime),
                                       temp: 0.0,
                                       conditionIconURL: nil,
                                       chanceOfPrecip: 0,
                                       sunRiseSetImage: "sunrise.fill",
                                       isSunset: false)
            hoursList.append(sunrise)
        }
        if let sunsetTime = forecastDay.astro.sunset {
            let sunset = ForecastHour(epoch: Int(sunsetTime.timeIntervalSince1970),
                                      time: hourMinFormatter.string(from: sunsetTime),
                                      temp: 0.0,
                                      conditionIconURL: nil,
                                      chanceOfPrecip: 0,
                                      sunRiseSetImage: "sunset.fill",
                                      isSunset: true)
            hoursList.append(sunset)
        }
        hoursList = hoursList.sorted {
            $0.epoch < $1.epoch
        }
        
        return hoursList
    }
    /// Parse out the Forecast days/hours list from the response data
    /// - Returns: Array of forecast day structures for the forecast days list
/*    func forecastDays_old() -> [ForcastDayViewModel] {
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
    */
    
    /// Get a condensed version of current weather for the `CurrentWeatherSummaryCell` Forecast and History list
    /// - Returns: CurrentWeatherModel populated with data
    func currentWeatherModel() -> CurrentWeatherModel {
        CurrentWeatherModel(location: locationName,
                            epochUpdated: weatherData?.current?.lastUpdatedEpoch ?? 0,
                            dateTime: timeLastUpdatedDate,
                            tempC: weatherData?.current?.tempC ?? 0.0,
                            tempF: weatherData?.current?.tempF ?? 0.0,
                            icon: weatherData?.current?.condition.icon ?? "",
                            code: weatherData?.current?.condition.code ?? 0,
                            uv: weatherData?.current?.uv ?? 0.0,
                            isDay: isDay)
    }
    
    /// Get the message for error if there is one.
    /// - Returns: Error message string
    func getErrorMessage() -> String {
        error?.localizedDescription ?? ""
    }
}

// MARK: Private

private extension WeatherViewModel {
    
    /// Process the result of the `WeatherDataSource.getForecast()`call and update view model state as needed.
    /// - Parameter result: The `Result<WeatherData, Error>` to be processed`
    func handleForcastCompletion(result: Result<WeatherData, Error>) {
        switch result {
        case .success(let data):
            weatherData = data
            if let errorResponse = data.error {
                self.error = ApiErrorType.fromErrorCode(code: errorResponse.code)
                state = .failure
            } else {
                state = .success
                isLoaded = true
            }
        case .failure(let error):
            self.error = error
            state = .failure
#if DEBUG
            print(error)
#endif
        }
    }
}
