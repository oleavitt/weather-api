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
        let endpoint: Endpoint = .current(key: "1234abcd", query: "Dallas", aqi: true)
        XCTAssertEqual(endpoint.url, "https://api.weatherapi.com/v1/current.json?key=1234abcd&q=Dallas&aqi=yes")
        
        let endpointNoAqi: Endpoint = .current(key: "1234abcd", query: "Dallas", aqi: false)
        XCTAssertEqual(endpointNoAqi.url, "https://api.weatherapi.com/v1/current.json?key=1234abcd&q=Dallas&aqi=no")
    }
}
