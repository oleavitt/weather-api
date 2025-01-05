//
//  EndpointTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
import SwiftUI
@testable import WeatherApi

final class EndpointTests: XCTestCase {

    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherApiKey = "1234abcd"
    }
    
    func testCurrent() {
        let endpoint = Endpoint.currentForecast(apiKey: weatherApiKey, query: "Dallas", aqi: true).url
        XCTAssertEqual(endpoint?.absoluteString, "https://api.weatherapi.com/v1/forecast.json?key=1234abcd&q=Dallas&days=14&aqi=yes")
        
        let endpointNoAqi = Endpoint.currentForecast(apiKey: weatherApiKey,query: "Dallas", aqi: false).url
        XCTAssertEqual(endpointNoAqi?.absoluteString, "https://api.weatherapi.com/v1/forecast.json?key=1234abcd&q=Dallas&days=14&aqi=no")
    }
}
