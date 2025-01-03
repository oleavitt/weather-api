//
//  Endpoint.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

private let apiHost = "api.weatherapi.com"

enum Endpoint {
    case currentForecast(apiKey: String, query: String, aqi: Bool)

    var url: URL? {
        switch self {
        case .currentForecast(let apiKey, let query, let aqi):
            var components = URLComponents()
            components.scheme = "https"
            components.host = apiHost
            components.path = "/v1/forecast.json"
            components.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "days", value: "14"),
                URLQueryItem(name: "aqi", value: aqi ? "yes" : "no")
            ]

            return components.url
        }
    }
    
    var request: URLRequest? {
        guard let url else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
    }
}
