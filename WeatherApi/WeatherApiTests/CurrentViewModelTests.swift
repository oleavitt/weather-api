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
        viewModel.locationQuery = "Dallas"
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertNotNil(viewModel.currentWeather?.location)
        if let location = viewModel.currentWeather?.location {
            XCTAssertEqual(location.name, "Dallas")
            XCTAssertEqual(location.region, "Texas")
            XCTAssertEqual(location.country, "United States of America")
            XCTAssertFalse(location.localtime.isEmpty)
        }
        
        XCTAssertNotNil(viewModel.currentWeather?.current)
        if let current = viewModel.currentWeather?.current {
            XCTAssertFalse(current.lastUpdated.isEmpty)
            XCTAssertNil(current.airQuality)
        }
        
        XCTAssertNil(viewModel.currentWeather?.error)
    }

    func testGetCurrentWithAqi() async throws {
        viewModel.locationQuery = "Dallas"
        viewModel.showAirQuality = true
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertNotNil(viewModel.currentWeather?.location)
        if let location = viewModel.currentWeather?.location {
            XCTAssertEqual(location.name, "Dallas")
            XCTAssertEqual(location.region, "Texas")
            XCTAssertEqual(location.country, "United States of America")
            XCTAssertFalse(location.localtime.isEmpty)
        }
        
        XCTAssertNotNil(viewModel.currentWeather?.current)
        if let current = viewModel.currentWeather?.current {
            XCTAssertFalse(current.lastUpdated.isEmpty)
            XCTAssertNotNil(current.airQuality)
        }

        XCTAssertNil(viewModel.currentWeather?.error)
    }
    
    func testGetCurrentErrorNoMatch() async throws {
        viewModel.locationQuery = "D"
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertNil(viewModel.currentWeather?.location)
        XCTAssertNil(viewModel.currentWeather?.current)
        XCTAssertNotNil(viewModel.currentWeather?.error)
        if let apiError = viewModel.currentWeather?.error {
            XCTAssertEqual(apiError.code, 1006)
            XCTAssertFalse(apiError.message.isEmpty)
        }
    }
    
    func testGetCurrentErrorEmpty() async throws {
        viewModel.locationQuery = ""
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.state, .loaded)
        
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertNil(viewModel.currentWeather?.location)
        XCTAssertNil(viewModel.currentWeather?.current)
        XCTAssertNotNil(viewModel.currentWeather?.error)
        if let apiError = viewModel.currentWeather?.error {
            XCTAssertEqual(apiError.code, 1003)
            XCTAssertFalse(apiError.message.isEmpty)
        }
    }
}
