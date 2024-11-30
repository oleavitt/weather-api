//
//  NetworkLayerMock.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/12/24.
//


import Foundation
import Combine

class NetworkLayerMock: NetworkLayer {
   
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        let query = request.url?.query() ?? ""
        let jsonString: String
        if query.contains("q=Dallas") {
            if query.contains("aqi=yes") {
                jsonString = currentWithAqiJson
            } else {
                jsonString = currentJson
            }
        } else {
            jsonString = currentErrorNoMatchJson
        }
        
        let data: Data
        switch type {
        case is ApiModel.Type:
            data = jsonString.data(using: .utf8) ?? Data()
            break
        default:
            data = Data()
            break
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

private let currentWithAqiJson = """
{
    "location": {
        "name": "Dallas",
        "region": "Texas",
        "country": "United States of America",
        "lat": 32.7833,
        "lon": -96.8,
        "tz_id": "America/Chicago",
        "localtime_epoch": 1731467231,
        "localtime": "2024-11-12 21:07"
    },
    "current": {
        "last_updated_epoch": 1731466800,
        "last_updated": "2024-11-12 21:00",
        "temp_c": 18.3,
        "temp_f": 64.89999999,
        "is_day": 0,
        "condition": {
            "text": "Partly cloudy",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
            "code": 1003
        },
        "wind_mph": 8.5,
        "wind_kph": 13.7,
        "wind_degree": 125,
        "wind_dir": "SE",
        "pressure_mb": 1013.0,
        "pressure_in": 29.92,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 56,
        "cloud": 75,
        "feelslike_c": 18.3,
        "feelslike_f": 64.9,
        "windchill_c": 19.3,
        "windchill_f": 66.7,
        "heatindex_c": 19.4,
        "heatindex_f": 67.0,
        "dewpoint_c": 11.6,
        "dewpoint_f": 52.9,
        "vis_km": 16.0,
        "vis_miles": 9.0,
        "uv": 0.0,
        "gust_mph": 13.1,
        "gust_kph": 21.1,
        "air_quality": {
            "co": 388.5,
            "no2": 20.535,
            "o3": 47.0,
            "so2": 4.44,
            "pm2_5": 13.32,
            "pm10": 19.24,
            "us-epa-index": 1,
            "gb-defra-index": 2
        }
    }
}
"""

private let currentJson = """
{
    "location": {
        "name": "Dallas",
        "region": "Texas",
        "country": "United States of America",
        "lat": 32.7833,
        "lon": -96.8,
        "tz_id": "America/Chicago",
        "localtime_epoch": 1731468427,
        "localtime": "2024-11-12 21:27"
    },
    "current": {
        "last_updated_epoch": 1731467700,
        "last_updated": "2024-11-12 21:15",
        "temp_c": 17.8,
        "temp_f": 64.0,
        "is_day": 0,
        "condition": {
            "text": "Partly cloudy",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
            "code": 1003
        },
        "wind_mph": 8.5,
        "wind_kph": 13.7,
        "wind_degree": 125,
        "wind_dir": "SE",
        "pressure_mb": 1014.0,
        "pressure_in": 29.93,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 56,
        "cloud": 75,
        "feelslike_c": 17.8,
        "feelslike_f": 64.0,
        "windchill_c": 19.3,
        "windchill_f": 66.7,
        "heatindex_c": 19.4,
        "heatindex_f": 67.0,
        "dewpoint_c": 11.6,
        "dewpoint_f": 52.9,
        "vis_km": 16.0,
        "vis_miles": 9.0,
        "uv": 0.0,
        "gust_mph": 13.1,
        "gust_kph": 21.1
    }
}
"""

private let currentErrorNoMatchJson = """
{
    "error": {
        "code": 1006,
        "message": "No matching location found."
    }
}
"""
