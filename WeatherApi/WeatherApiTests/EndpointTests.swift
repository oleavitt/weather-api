//
//  EndpointTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
@testable import WeatherApi

final class EndpointTests: XCTestCase {

    func testCurrent() {
        apiKey = "1234abcd"
        let endpoint = Endpoint.currentForecast(query: "Dallas", aqi: true).url
        XCTAssertEqual(endpoint?.absoluteString, "https://api.weatherapi.com/v1/forecast.json?key=1234abcd&q=Dallas&days=14&aqi=yes")
        
        let endpointNoAqi = Endpoint.currentForecast(query: "Dallas", aqi: false).url
        XCTAssertEqual(endpointNoAqi?.absoluteString, "https://api.weatherapi.com/v1/forecast.json?key=1234abcd&q=Dallas&days=14&aqi=no")
    }
}
