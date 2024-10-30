//
//  CurrentViewModelTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
@testable import WeatherApi

final class CurrentViewModelTests: XCTestCase {

    var viewModel = CurrentViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiKey = "YOUR_API_KEY"
        viewModel = CurrentViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCurrent() async throws {
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertNotNil(viewModel.currentWeather)
        if let currentWeather = viewModel.currentWeather {
            XCTAssertEqual(currentWeather.location.name, "Dallas")
            XCTAssertEqual(currentWeather.location.region, "Texas")
            XCTAssertEqual(currentWeather.location.country, "United States of America")
            XCTAssertFalse(currentWeather.location.localtime.isEmpty)
            
            XCTAssertFalse(currentWeather.current.lastUpdated.isEmpty)
            XCTAssertNil(currentWeather.current.airQuality)
        }
    }

    func testGetCurrentWithAqi() async throws {
        viewModel.showAirQuality = true
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertNotNil(viewModel.currentWeather)
        if let currentWeather = viewModel.currentWeather {
            XCTAssertEqual(currentWeather.location.name, "Dallas")
            XCTAssertEqual(currentWeather.location.region, "Texas")
            XCTAssertEqual(currentWeather.location.country, "United States of America")
            XCTAssertFalse(currentWeather.location.localtime.isEmpty)
            
            XCTAssertFalse(currentWeather.current.lastUpdated.isEmpty)
            XCTAssertNotNil(currentWeather.current.airQuality)
        }
    }
}
