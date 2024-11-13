//
//  CurrentViewModelTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
@testable import WeatherApi

final class CurrentViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiKey = ""
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCurrent() async throws {
        let viewModel = CurrentViewModel(NetworkLayerMock())
        viewModel.locationQuery = "Dallas"
        await viewModel.getCurrentWeather()
        
        if case let .success(current) = viewModel.state {
            XCTAssertNotNil(current.location)
            if let location = current.location {
                XCTAssertEqual(location.name, "Dallas")
                XCTAssertEqual(location.region, "Texas")
                XCTAssertEqual(location.country, "United States of America")
                XCTAssertFalse(location.localtime.isEmpty)
            }
            
            XCTAssertNotNil(current.current)
            if let current = current.current {
                XCTAssertFalse(current.lastUpdated.isEmpty)
                XCTAssertNil(current.airQuality)
            }
            
            XCTAssertNil(current.error)
        } else {
            XCTFail("View model state is not successful")
        }
    }

    func testGetCurrentWithAqi() async throws {
        let viewModel = CurrentViewModel(NetworkLayerMock())
        viewModel.locationQuery = "Dallas"
        viewModel.showAirQuality = true
        await viewModel.getCurrentWeather()
        
        if case let .success(current) = viewModel.state {
            XCTAssertNotNil(current.location)
            if let location = current.location {
                XCTAssertEqual(location.name, "Dallas")
                XCTAssertEqual(location.region, "Texas")
                XCTAssertEqual(location.country, "United States of America")
                XCTAssertFalse(location.localtime.isEmpty)
            }
            
            XCTAssertNotNil(current.current)
            if let current = current.current {
                XCTAssertFalse(current.lastUpdated.isEmpty)
                XCTAssertNotNil(current.airQuality)
            }
            
            XCTAssertNil(current.error)
        } else {
            XCTFail("View model state is not the error state")
        }
    }
    
    func testGetCurrentErrorNoMatch() async throws {
        let viewModel = CurrentViewModel(NetworkLayerMock())
        viewModel.locationQuery = "D"
        await viewModel.getCurrentWeather()
        
        if case let .failure(error) = viewModel.state {
            XCTAssertEqual(error as? ApiErrorType, .noMatch)
        } else {
            XCTFail("View model state is not the error state")
        }
    }
}
