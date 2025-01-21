//
//  WeatherApiModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/18/25.
//

import Foundation

/// Universal top level response model returned by call to WeatherAPI endpoint
struct WeatherApiModel: Decodable {
    var location: Location?
    var current: Current?
    var forecast: Forecast?
    var error: ApiError?
}

struct Current: Decodable {
    var lastUpdated: String?
    var lastUpdatedEpoch: Int?
    var timeEpoch: Int?
    var tempC: Double = 0.0
    var tempF: Double = 0.0
    var isDay: Int = 0
    var condition: Condition
    var windMph: Double = 0.0
    var windKph: Double = 0.0
    var windDegree: Int = 0
    var windDir: String = ""
    var pressureMb: Double = 0.0
    var pressureIn: Double = 0.0
    var precipMm: Double = 0.0
    var precipIn: Double = 0.0
    var humidity: Int = 0
    var cloud: Int = 0
    var feelslikeC: Double = 0.0
    var feelslikeF: Double = 0.0
    var windchillC: Double = 0.0
    var windchillF: Double = 0.0
    var heatindexC: Double = 0.0
    var heatindexF: Double = 0.0
    var dewpointC: Double = 0.0
    var dewpointF: Double = 0.0
    var visKm: Double = 0.0
    var visMiles: Double = 0.0
    var uv: Double = 0.0
    var gustMph: Double = 0.0
    var gustKph: Double = 0.0
    var airQuality: AirQuality?
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case lastUpdatedEpoch = "last_updated_epoch"
        case timeEpoch = "time_epoch"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition = "condition"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity = "humidity"
        case cloud = "cloud"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case uv = "uv"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case airQuality = "air_quality"
    }
}

struct Condition: Decodable {
    var text: String = ""
    var icon: String = ""
    var code: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case icon = "icon"
        case code = "code"
    }
}

struct AirQuality: Decodable {
    var co: Double
    var no2: Double
    var o3: Double
    var so2: Double
    var pm25: Double
    var pm10: Double
    var usEpaIndex: Int
    var gbDefraIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case co = "co"
        case no2 = "no2"
        case o3 = "o3"
        case so2 = "so2"
        case pm25 = "pm2_5"
        case pm10 = "pm10"
        case usEpaIndex = "us-epa-index"
        case gbDefraIndex = "gb-defra-index"
    }
}

// MARK: - Forecast
struct Forecast: Decodable {
    let forecastDay: [ForecastDayModel]
    enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

// MARK: - ForecastDayModel
struct ForecastDayModel: Decodable {
    let astro: Astro
    let hour: [ForecastHourModel]
    let day: Day
    let dateEpoch: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case astro, hour, day
        case dateEpoch = "date_epoch"
        case date
    }
}

// MARK: - ForecastHourModel
struct ForecastHourModel: Decodable {
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
    let condition: Condition
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
    let time: String
    let pressureMB: Double
    let willItRain: Int
    let visKM: Double
    
    enum CodingKeys: String, CodingKey {
        case visMiles = "vis_miles"
        case isDay = "is_day"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case windDir = "wind_dir"
        case humidity
        case heatindexC = "heatindex_c"
        case gustMph = "gust_mph"
        case windKph = "wind_kph"
        case windchillC = "windchill_c"
        case chanceOfSnow = "chance_of_snow"
        case timeEpoch = "time_epoch"
        case tempF = "temp_f"
        case condition
        case feelslikeF = "feelslike_f"
        case dewpointC = "dewpoint_c"
        case snowCM = "snow_cm"
        case uv, cloud
        case gustKph = "gust_kph"
        case tempC = "temp_c"
        case precipIn = "precip_in"
        case heatindexF = "heatindex_f"
        case dewpointF = "dewpoint_f"
        case windMph = "wind_mph"
        case windDegree = "wind_degree"
        case feelslikeC = "feelslike_c"
        case windchillF = "windchill_f"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case time
        case pressureMB = "pressure_mb"
        case willItRain = "will_it_rain"
        case visKM = "vis_km"
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunset: String
    let isSunUp: Int
    let moonrise: String
    let moonIllumination: Int
    let sunrise: String
    let moonPhase: String
    let moonset: String
    let isMoonUp: Int
    
    enum CodingKeys: String, CodingKey {
        case sunset
        case isSunUp = "is_sun_up"
        case moonrise
        case moonIllumination = "moon_illumination"
        case sunrise
        case moonPhase = "moon_phase"
        case moonset
        case isMoonUp = "is_moon_up"
    }
}

// MARK: - Day
struct Day: Decodable {
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
    let avghumidity, totalprecipMm: Double
    let condition: Condition
    let maxwindMph: Double
    let maxwindKph: Double
    let uv: Double
    
    enum CodingKeys: String, CodingKey {
        case avgvisKM = "avgvis_km"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case totalPrecipIn = "totalprecip_in"
        case totalSnowCM = "totalsnow_cm"
        case dailyWillItRain = "daily_will_it_rain"
        case maxtempF = "maxtemp_f"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case avghumidity
        case totalprecipMm = "totalprecip_mm"
        case condition
        case maxwindKph = "maxwind_kph"
        case maxwindMph = "maxwind_mph"
        case avgvisMiles = "avgvis_miles"
        case uv
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case mintempF = "mintemp_f"
        case avgtempF = "avgtemp_f"
        case maxtempC = "maxtemp_c"
    }
}

// MARK: - Location
struct Location: Codable {
    let region, country, localtime: String
    let lon, lat: Double
    let tzID, name: String
    let localtimeEpoch: Int
    
    enum CodingKeys: String, CodingKey {
        case region, country, localtime, lon, lat
        case tzID = "tz_id"
        case name
        case localtimeEpoch = "localtime_epoch"
    }
}

struct ApiError: Decodable {
    var code: Int
    var message: String
}
