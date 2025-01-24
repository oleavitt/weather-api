//
//  WeatherDataSource.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/18/25.
//

import Foundation
import Combine

/// Abstract interface for fetching weather data from the actual source
protocol WeatherDataSource {
    func setup(networkLayer: NetworkLayer, apiKey: String)
    func getForecast(locationQuery: String, includeAqi: Bool, completion: @escaping (Result<WeatherData, Error>)->Void)
}

// MARK: Top level API structure

struct WeatherData {
    var location: LocationData?
    var current: CurrentData?
    var forecast: ForecastData?
    var error: ApiErrorData?
}

// MARK: API Location

struct LocationData {
    let name: String
    let region: String
    let country: String
    let localtime: Date?
    let localtimeEpoch: Int
    let lon: Double
    let lat: Double
    let tzID: String
}

// MARK: API Current

struct CurrentData {
    let dateTimeLastUpdated: Date?
    let lastUpdatedEpoch: Int
    let tempC: Double
    let tempF: Double
    let isDay: Int
    let condition: ConditionData
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let feelslikeF: Double
    let windchillC: Double
    let windchillF: Double
    let heatindexC: Double
    let heatindexF: Double
    let dewpointC: Double
    let dewpointF: Double
    let visKm: Double
    let visMiles: Double
    let uv: Double
    let gustMph: Double
    let gustKph: Double
    let airQuality: AirQualityData?
}

struct ConditionData {
    let text: String
    let icon: String
    let code: Int
}

struct AirQualityData {
    var co: Double
    var no2: Double
    var o3: Double
    var so2: Double
    var pm25: Double
    var pm10: Double
    var usEpaIndex: Int
    var gbDefraIndex: Int
}

// MARK: API Forecast

struct ForecastData {
    let forecastDays: [ForecastDayData]
}

struct ForecastDayData {
    let astro: AstroData
    let forecastHours: [ForecastHourData]
    let day: DayData
    let dateEpoch: Int
    let date: Date?
}

struct DayData {
    let avgvisKM: Double
    let avgvisMiles: Double
    let mintempF: Double
    let mintempC: Double
    let avgtempF: Double
    let avgtempC: Double
    let maxtempF: Double
    let maxtempC: Double
    let totalPrecipIn: Double
    let totalSnowCM: Double
    let dailyWillItRain: Int
    let dailyWillItSnow: Int
    let dailyChanceOfRain: Int
    let dailyChanceOfSnow: Int
    let avghumidity: Double
    let totalprecipMm: Double
    let condition: ConditionData
    let maxwindMph: Double
    let maxwindKph: Double
    let uv: Double
}

struct ForecastHourData {
    let visMiles: Double
    let isDay: Int
    let pressureIn: Double
    let precipMm: Double
    let windDir: String
    let humidity: Double
    let heatindexC: Double
    let gustMph: Double
    let windKph: Double
    let windchillC: Double
    let chanceOfSnow: Int
    let timeEpoch: Int
    let tempF: Double
    let condition: ConditionData
    let feelslikeF: Double
    let dewpointC: Double
    let snowCM: Double
    let uv: Double
    let cloud: Int
    let gustKph: Double
    let tempC: Double
    let precipIn: Double
    let heatindexF: Double
    let dewpointF: Double
    let windMph: Double
    let windDegree: Int
    let feelslikeC: Double
    let windchillF: Double
    let chanceOfRain: Int
    let willItSnow: Int
    let time: Date?
    let pressureMB: Double
    let willItRain: Int
    let visKM: Double
}

struct AstroData {
    let isSunUp: Int
    let sunrise: Date?
    let sunset: Date?
    let isMoonUp: Int
    let moonrise: Date?
    let moonset: Date?
    let moonIllumination: Int
    let moonPhase: String
}

// MARK: API Error

struct ApiErrorData {
    var code: Int
    var message: String
}
