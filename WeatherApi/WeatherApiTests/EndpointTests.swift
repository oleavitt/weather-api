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
        let endpoint = Endpoint.current(query: "Dallas", aqi: true).url
        XCTAssertEqual(endpoint?.absoluteString, "https://api.weatherapi.com/v1/current.json?key=1234abcd&q=Dallas&aqi=yes")
        
        let endpointNoAqi = Endpoint.current(query: "Dallas", aqi: false).url
        XCTAssertEqual(endpointNoAqi?.absoluteString, "https://api.weatherapi.com/v1/current.json?key=1234abcd&q=Dallas&aqi=no")
    }
}
