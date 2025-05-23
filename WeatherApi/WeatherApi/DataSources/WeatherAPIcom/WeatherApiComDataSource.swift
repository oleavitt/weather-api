//
//  WeatherApiComDataSource.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/19/25.
//

import Foundation
import Combine

/// Implements a `WeatherDataSource` interface to get weather data from WeatherAPI.com
/// See https://www.weatherapi.com/
class WeatherApiComDataSource: WeatherDataSource {

    private let apiHost = "api.weatherapi.com"
    private var apiKey = ""
    private var networkLayer: NetworkLayer?
    private var cancellable: AnyCancellable?
    private var apiModel: WeatherApiModel?

    /// Sets up data source to be ready to make API calls
    /// - Parameters:
    ///   - networkLayer: `NetworkLayer` to handle the networking
    ///   - apiKey: Required API key to pass to the API
    func setup(networkLayer: any NetworkLayer, apiKey: String = "") {
        self.networkLayer = networkLayer
        self.apiKey = apiKey
    }

    /// Gets the current and forecast weather information from the API
    /// - Parameters:
    ///   - locationQuery: Required location query for API
    ///   - includeAqi: Set true to include air quality information
    ///   - completion: Completion block to recieve a `WeatherData` struct if successful
    ///    or an `Error` if API call was unsuccessful
    func getForecast(
        locationQuery: String,
        includeAqi: Bool,
        completion: @escaping (Result<WeatherData, Error>) -> Void
    ) {
        guard let networkLayer,
              let request = createForcastRequest(query: locationQuery, aqi: includeAqi) else {
            completion(.failure(ApiErrorType.genericError))
            return
        }

        cancellable = networkLayer.fetchJsonDataPublisher(request: request, type: WeatherApiModel.self)
            .map { self.mapResponseData($0) }
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    switch error {
                    case let decodingError as DecodingError:
                        completion(.failure(decodingError))
                    default:
                        completion(.failure(ApiErrorType.genericError))
                    }
                }
            },
                  receiveValue: { completion(.success($0)) })
    }

    /// Date and time of last update on data source end.
    var dateTimeLastUpdated: Date? {
        guard let current = apiModel?.current else { return nil }
        return localDateTime(current.lastUpdated)
    }

    /// Location details for this weather report.
    var locationData: LocationData? {
        guard let location = apiModel?.location else { return nil }
        return LocationData(name: location.name,
                            region: location.region,
                            country: location.country,
                            latitude: location.lat,
                            longitude: location.lon)
    }

    /// The current temperature in user's selected temperature units (F or C).
    func currentTemp(units: TempUnits) -> Double? {
        (units == .fahrenheit) ? apiModel?.current?.tempF : apiModel?.current?.tempC
    }
}

// MARK: - Private

private extension WeatherApiComDataSource {
    /// Builds a URL request to get current and forecast weather information from the API
    /// - Parameters:
    ///   - query: Required location query for API
    ///   - aqi: Include air quality information
    /// - Returns: a `URLRequest` to perform the API call with
    func createForcastRequest(query: String, aqi: Bool) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = apiHost
        components.path = "/v1/forecast.json"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "alerts", value: "yes"),
            URLQueryItem(name: "aqi", value: aqi ? "yes" : "no")
        ]

        guard let url = components.url else {
            return nil
        }

        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
    }

    /// Map top level response model returned from the API to a WeatherData struct
    /// - Parameter sourceData: API specific root response model
    /// - Returns: `WeatherData` with weather info or error info if an API error occurred
    func mapResponseData(_ sourceData: WeatherApiModel) -> WeatherData {
        var weatherData = WeatherData()

        // Save a local copy of the source data
        apiModel = sourceData

        weatherData.current = mapCurrentData(sourceData)
        weatherData.forecast = mapForecastData(sourceData)
        weatherData.error = mapApiErrorData(sourceData)
        weatherData.alerts = mapAlertsData(sourceData)

        return weatherData
    }

    /// Map any current weather information returned from the API to a CurrentData struct
    /// - Parameter sourceData: API specific root response model
    /// - Returns: `CurrentData` with current weather info or nil if none
    func mapCurrentData(_ sourceData: WeatherApiModel) -> CurrentData? {
        guard let srcCurrent = sourceData.current else { return nil }

        var airQuality: AirQualityData?
        if let srcAirQuality = srcCurrent.airQuality {
            airQuality = AirQualityData(
                co: srcAirQuality.co,
                no2: srcAirQuality.no2,
                o3: srcAirQuality.o3,
                so2: srcAirQuality.so2,
                pm25: srcAirQuality.pm25,
                pm10: srcAirQuality.pm10,
                usEpaIndex: srcAirQuality.usEpaIndex,
                gbDefraIndex: srcAirQuality.gbDefraIndex)
        }

        let current = CurrentData(
            isDay: srcCurrent.isDay,
            condition: ConditionData(
                text: srcCurrent.condition.text,
                icon: srcCurrent.condition.icon,
                code: srcCurrent.condition.code),
            windMph: srcCurrent.windMph, windKph: srcCurrent.windKph,
            windDegree: srcCurrent.windDegree, windDir: srcCurrent.windDir,
            pressureMb: srcCurrent.pressureMb, pressureIn: srcCurrent.pressureIn,
            precipMm: srcCurrent.precipMm, precipIn: srcCurrent.precipIn,
            humidity: srcCurrent.humidity,
            cloud: srcCurrent.cloud,
            feelslikeC: srcCurrent.feelslikeC, feelslikeF: srcCurrent.feelslikeF,
            windchillC: srcCurrent.windchillC, windchillF: srcCurrent.windchillF,
            heatindexC: srcCurrent.heatindexC, heatindexF: srcCurrent.heatindexF,
            dewpointC: srcCurrent.dewpointC, dewpointF: srcCurrent.dewpointF,
            visKm: srcCurrent.visKm, visMiles: srcCurrent.visMiles,
            uv: srcCurrent.uv,
            gustMph: srcCurrent.gustMph, gustKph: srcCurrent.gustKph,
            airQuality: airQuality)

        return current
    }

    // swiftlint:disable function_body_length
    /// Map any forecast information returned from the API to a ForecastData struct
    /// - Parameter sourceData: API specific root response model
    /// - Returns: `ForecastData` with daily and hourly forecast info or nil if none
    func mapForecastData(_ sourceData: WeatherApiModel) -> ForecastData? {
        guard let srcForecast = sourceData.forecast else { return nil }

        let dateFromDayFormatter = DateFormatter()
        dateFromDayFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromHourFormatter = DateFormatter()
        dateFromHourFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let forecastDays = srcForecast.forecastDay.map { srcForecastDay in
            let forecastHours = srcForecastDay.hour.map { srcHour in
                ForecastHourData(visMiles: srcHour.visMiles,
                                 isDay: srcHour.isDay,
                                 pressureIn: srcHour.pressureIn,
                                 precipMm: srcHour.precipMm,
                                 windDir: srcHour.windDir,
                                 humidity: srcHour.humidity,
                                 heatindexC: srcHour.heatindexC,
                                 gustMph: srcHour.gustMph,
                                 windKph: srcHour.windKph,
                                 windchillC: srcHour.windchillC,
                                 chanceOfSnow: srcHour.chanceOfSnow,
                                 timeEpoch: srcHour.timeEpoch,
                                 tempF: srcHour.tempF,
                                 condition: ConditionData(
                                    text: srcHour.condition.text,
                                    icon: srcHour.condition.icon,
                                    code: srcHour.condition.code),
                                 feelslikeF: srcHour.feelslikeF,
                                 dewpointC: srcHour.dewpointC,
                                 snowCM: srcHour.snowCM,
                                 uv: srcHour.uv,
                                 cloud: srcHour.cloud,
                                 gustKph: srcHour.gustKph,
                                 tempC: srcHour.tempC,
                                 precipIn: srcHour.precipIn,
                                 heatindexF: srcHour.heatindexF,
                                 dewpointF: srcHour.dewpointF,
                                 windMph: srcHour.windMph,
                                 windDegree: srcHour.windDegree,
                                 feelslikeC: srcHour.feelslikeC,
                                 windchillF: srcHour.windchillF,
                                 chanceOfRain: srcHour.chanceOfRain,
                                 willItSnow: srcHour.willItSnow,
                                 time: dateFromHourFormatter.date(from: srcHour.time),
                                 pressureMB: srcHour.pressureMB,
                                 willItRain: srcHour.willItRain,
                                 visKM: srcHour.visKM)
            }

            let astro = srcForecastDay.astro
            let astroData = AstroData(isSunUp: astro.isSunUp,
                                      sunrise: riseSetDate(date: srcForecastDay.date, time: astro.sunrise),
                                      sunset: riseSetDate(date: srcForecastDay.date, time: astro.sunset),
                                      isMoonUp: astro.isMoonUp,
                                      moonrise: riseSetDate(date: srcForecastDay.date, time: astro.moonrise),
                                      moonset: riseSetDate(date: srcForecastDay.date, time: astro.moonset),
                                      moonIllumination: astro.moonIllumination,
                                      moonPhase: astro.moonPhase)

            let day = srcForecastDay.day
            let dayData = DayData(avgvisKM: day.avgvisKM, avgvisMiles: day.avgvisMiles,
                                  mintempF: day.mintempF, mintempC: day.mintempC,
                                  avgtempF: day.avgtempF, avgtempC: day.avgtempC,
                                  maxtempF: day.maxtempF, maxtempC: day.maxtempC,
                                  totalPrecipIn: day.totalPrecipIn,
                                  totalSnowCM: day.totalSnowCM,
                                  dailyWillItRain: day.dailyWillItRain, dailyWillItSnow: day.dailyWillItSnow,
                                  dailyChanceOfRain: day.dailyChanceOfRain, dailyChanceOfSnow: day.dailyChanceOfSnow,
                                  avghumidity: day.avghumidity,
                                  totalprecipMm: day.totalprecipMm,
                                  condition: ConditionData(
                                    text: day.condition.text,
                                    icon: day.condition.icon,
                                    code: day.condition.code),
                                  maxwindMph: day.maxwindMph, maxwindKph: day.maxwindKph,
                                  uv: day.uv)

            return ForecastDayData(astro: astroData,
                                   forecastHours: forecastHours,
                                   day: dayData,
                                   dateEpoch: srcForecastDay.dateEpoch,
                                   date: dateFromDayFormatter.date(from: srcForecastDay.date) ?? Date())
        }

        return ForecastData(forecastDays: forecastDays)
    }
    // swiftlint:enable function_body_length

    /// Map any error returned from the API to a ApiErrorData struct
    /// - Parameter sourceData: API specific root response model
    /// - Returns: `ApiErrorData` with error info or nil if no error
    func mapApiErrorData(_ sourceData: WeatherApiModel) -> ApiErrorData? {
        guard let srcError = sourceData.error else { return nil }

        return ApiErrorData(code: srcError.code,
                            message: srcError.message)
    }

    func mapAlertsData(_ sourceData: WeatherApiModel) -> WeatherDataAlerts? {
        guard let wapiAlerts = sourceData.alerts?.alert else { return nil }
        let alerts = wapiAlerts.compactMap { wapiAlert in
            WeatherDataAlert(id: UUID(),
                             category: wapiAlert.category,
                             msgtype: wapiAlert.msgtype,
                             note: wapiAlert.note,
                             headline: wapiAlert.headline,
                             effective: alertDateTime(wapiAlert.effective),
                             event: wapiAlert.event,
                             expires: alertDateTime(wapiAlert.expires),
                             desc: wapiAlert.desc,
                             instruction: wapiAlert.instruction,
                             urgency: wapiAlert.urgency,
                             severity: wapiAlert.severity,
                             areas: wapiAlert.areas,
                             certainty: wapiAlert.certainty)
        }
        return WeatherDataAlerts(alerts: alerts)
    }

    func riseSetDate(date: String, time: String) -> Date? {
        let riseSetInputFormatter = DateFormatter()
        riseSetInputFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        return riseSetInputFormatter.date(from: "\(date) \(time)")
    }

    func localDateTime(_ dateTime: String?) -> Date? {
        guard let dateTime else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: dateTime)
    }

    func alertDateTime(_ dateTime: String?) -> Date? {
        guard let dateTime else { return nil }
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withFullTime]
        return isoDateFormatter.date(from: dateTime)
    }
}
