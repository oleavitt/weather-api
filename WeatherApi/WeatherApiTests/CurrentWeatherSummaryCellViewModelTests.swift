//
//  CurrentWeatherSummaryCellViewModelTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 1/5/25.
//

import XCTest
import SwiftUI
@testable import WeatherApi

final class CurrentWeatherSummaryCellViewModelTests: XCTestCase {

    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit

    let viewModel = CurrentWeatherSummaryCellViewModel(data: CurrentWeatherModel(
        location: "Dallas, Texas",
        dateTime: Date(),
        tempC: 17.8,
        tempF: 64,
        icon: "//cdn.weatherapi.com/weather/64x64/night/119.png",
        code: 1000,
        uv: 0,
        isDay: false))
    
    func testPropertiesFahrenheit() {
        tempUnitsSetting = .fahrenheit
        XCTAssertFalse(viewModel.isDay)
        XCTAssertFalse(viewModel.date.isEmpty)
        XCTAssertFalse(viewModel.time.isEmpty)
        XCTAssertEqual(viewModel.location, "Dallas, Texas")
        XCTAssertEqual(viewModel.temperature, "64°")
        XCTAssertNotNil(viewModel.iconURL)
    }
    
    func testPropertiesTempCelsius() {
        tempUnitsSetting = .celsius
        XCTAssertFalse(viewModel.isDay)
        XCTAssertFalse(viewModel.date.isEmpty)
        XCTAssertFalse(viewModel.time.isEmpty)
        XCTAssertEqual(viewModel.location, "Dallas, Texas")
        XCTAssertEqual(viewModel.temperature, "17.8°")
        XCTAssertNotNil(viewModel.iconURL)
    }
}
