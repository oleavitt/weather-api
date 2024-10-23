//
//  Endpoint.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

private let baseUrl = "https://api.weatherapi.com/v1/"

enum Endpoint {
    case current(key: String, query: String, aqi: Bool)
    
    var  url: String {
        switch self {
        case .current(let key, let query, let aqi):
            return baseUrl + "current.json" +
                "?key=" + key +
                "&q=" + query +
                "&aqi=" + (aqi ? "yes" : "no")
        }
    }
}
