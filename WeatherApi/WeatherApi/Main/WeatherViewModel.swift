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
    /// Location search query that is passed to the API.
    var locationQuery = ""

    /// Indicator set from view to indicate we are using user's location for search.
    var isUserLocation = true

    @Published var state: LoadingState = .startup
    @Published var isLoaded = false

    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit
    @AppStorage(AppSettings.unitsSpeed.rawValue) var speedUnitsSetting: SpeedUnits = .mph
    @AppStorage(AppSettings.unitsPressure.rawValue) var pressureUnitsSetting: PressureUnits = .inchesHg

    /// Network layer interface that is injected into view model at the time of creation.
    private let networkLayer: NetworkLayer

    /// Set true to include air quality (AQI) results in API response
    private var showAirQuality = false

    /// Weather data source interface
    private var weatherDataSource: WeatherDataSource = WeatherApiComDataSource()

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
            error = ApiErrorType.noApiKey
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

// MARK: Display content for views

/// Computed properties that format response data using user's preferred units settings.
extension WeatherViewModel {
    /// Return a full https URL to the icon resource from the relative path returned in the API response.
    var conditionsIconUrl: URL? {
        URL.httpsURL(weatherData?.current?.condition.icon)
    }

    var tempString: String {
        if let temp = weatherDataSource.currentTemp(units: tempUnitsSetting) {
            return temp.formatted() + "°"
        }
        return "--"
    }

    var timeLastUpdatedFormatted: String {
        timeLastUpdatedDate.formatted(date: .abbreviated, time: .shortened)
    }

    var locationName: String {
        guard let location = weatherDataSource.locationData else { return "--" }
        return "\(location.name), \(location.region)"
    }

    var condition: String {
        weatherData?.current?.condition.text ?? "--"
    }

    var feelsLike: String {
        if let temp = (tempUnitsSetting == .fahrenheit)
            ? weatherData?.current?.feelslikeF
            : weatherData?.current?.feelslikeC {
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
        if let pressure = (pressureUnitsSetting == .inchesHg)
            ? weatherData?.current?.pressureIn
            : weatherData?.current?.pressureMb {
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
    func forecastDays() -> [ForcastDayRowViewModel] {
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
            return ForcastDayRowViewModel(epoch: forecastDay.dateEpoch,
                                       date: forecastDay.date,
                                       highTemp: maxTemp,
                                       lowTemp: minTemp,
                                       conditionIconURL: URL.httpsURL(forecastDay.day.condition.icon),
                                       condition: forecastDay.day.condition.text,
                                       chanceOfPrecip: forecastDay.day.dailyChanceOfRain,
                                       chanceOfSnow: forecastDay.day.dailyChanceOfSnow,
                                       hours: forecastHours(forecastDay: forecastDay))
        } ?? []
    }

    /// Parse out the hours list for the given day from
    /// the response data ans insert the sunrise/set times if theye are there
    /// - Parameter forecastDay: The forecast day
    /// - Returns: The hours list including sunrise and sunset times
    private func forecastHours(forecastDay: ForecastDayData) -> [ForecastHour] {
        // Build the 24 hour list
        var hoursList: [ForecastHour] = forecastDay.forecastHours.map { hour in
            let temp: Double
            if tempUnitsSetting == .fahrenheit {
                temp = hour.tempF
            } else {
                temp = hour.tempC
            }
            let intHour = Calendar.current.component(.hour, from: hour.time ?? Date())
            return ForecastHour(epoch: hour.timeEpoch,
                                time: hour.time,
                                hour: intHour,
                                temp: temp,
                                conditionIconURL: URL.httpsURL(hour.condition.icon),
                                condition: hour.condition.text,
                                chanceOfPrecip: hour.chanceOfRain)
        }

        // Insert the sunrise and sunset times
        // Sunrise has an hour identifier of -1, sunset is -2
        if let sunriseTime = forecastDay.astro.sunrise {
            let sunrise = ForecastHour(epoch: Int(sunriseTime.timeIntervalSince1970),
                                       time: sunriseTime,
                                       hour: ForecastHour.hourSunrise,
                                       temp: 0.0,
                                       conditionIconURL: nil,
                                       condition: "",
                                       chanceOfPrecip: 0,
                                       sunRiseSetImage: "sunrise.fill")
            hoursList.append(sunrise)
        }
        if let sunsetTime = forecastDay.astro.sunset {
            let sunset = ForecastHour(epoch: Int(sunsetTime.timeIntervalSince1970),
                                      time: sunsetTime,
                                      hour: ForecastHour.hourSunset,
                                      temp: 0.0,
                                      conditionIconURL: nil,
                                      condition: "",
                                      chanceOfPrecip: 0,
                                      sunRiseSetImage: "sunset.fill")
            hoursList.append(sunset)
        }
        hoursList = hoursList.sorted {
            if $0.epoch == $1.epoch {
                // Case where sunrise/sunset is exactly on the hour
                return $0.isSunset
            }
            return $0.epoch < $1.epoch
        }

        return hoursList
    }

    /// Any active alerts for this forecast area.
    var alerts: [WeatherDataAlert] {
        weatherDataSource.alerts?.alerts ?? []
    }

    /// Return true if there are alerts to show.
    var hasAlerts: Bool {
        !alerts.isEmpty
    }

    /// Gather current weather data to save to the History data store.
    /// - Returns: HistoryItemModel populated with data.
    func historyItemModel() -> HistoryItemModel {
        HistoryItemModel(location: locationName,
                         dateTime: timeLastUpdatedDate,
                         tempC: weatherDataSource.currentTemp(units: .celsius) ?? 0.0,
                         tempF: weatherDataSource.currentTemp(units: .fahrenheit) ?? 0.0,
                         icon: weatherData?.current?.condition.icon ?? "",
                         condition: weatherData?.current?.condition.text ?? "",
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

// MARK: Data loading

extension WeatherViewModel {
    func loadDataFromLocation(locationManager: LocationManager) {
        locationManager.requestAuthorization { [weak self] in
            locationManager.requestLocation {
                self?.isUserLocation = true
                self?.locationQuery = locationManager.locationString ?? "auto:ip"
                self?.loadData()
            }
        }
    }

    func reloadData(locationManager: LocationManager) {
        if isUserLocation || locationQuery.isEmpty {
            loadDataFromLocation(locationManager: locationManager)
        } else {
            loadData()
        }
    }

    func loadData() {
        getCurrentAndForecastWeather()
    }
}

// MARK: Private

private extension WeatherViewModel {
    var timeLastUpdatedDate: Date {
        return weatherDataSource.dateTimeLastUpdated ?? Date()
    }

    var tempUnits: String {
        tempUnitsSetting.symbol
    }

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
