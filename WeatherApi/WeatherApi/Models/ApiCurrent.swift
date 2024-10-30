//
//  ApiCurrent.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/24/24.
//

import Foundation
/*
{
    "location": {
        "name": "Dallas",
        "region": "Texas",
        "country": "United States of America",
        "lat": 32.7833,
        "lon": -96.8,
        "tz_id": "America/Chicago",
        "localtime_epoch": 1729821767,
        "localtime": "2024-10-24 21:02"
    },
    "current": {
        "last_updated_epoch": 1729821600,
        "last_updated": "2024-10-24 21:00",
        "temp_c": 26.7,
        "temp_f": 80.1,
        "is_day": 0,
        "condition": {
            "text": "Clear",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
            "code": 1000
        },
        "wind_mph": 9.2,
        "wind_kph": 14.8,
        "wind_degree": 176,
        "wind_dir": "S",
        "pressure_mb": 1014.0,
        "pressure_in": 29.94,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 45,
        "cloud": 0,
        "feelslike_c": 27.9,
        "feelslike_f": 82.2,
        "windchill_c": 25.5,
        "windchill_f": 78.0,
        "heatindex_c": 26.7,
        "heatindex_f": 80.1,
        "dewpoint_c": 16.7,
        "dewpoint_f": 62.1,
        "vis_km": 16.0,
        "vis_miles": 9.0,
        "uv": 0.0,
        "gust_mph": 16.2,
        "gust_kph": 26.1
    }
}
 */

struct ApiCurrent: Decodable {
    var location: Location
    var current: Current
}

struct Location: Decodable {
    var name: String = ""
    var region: String = ""
    var country: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var tzId: String = ""
    var localtimeEpoch: Int = 0
    var localtime: String = ""

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime = "localtime"
    }
}

struct Current: Decodable {
    
}
