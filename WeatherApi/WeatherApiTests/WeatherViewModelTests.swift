//
//  WeatherViewModelTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
import SwiftUI
import Combine

@testable import WeatherApi

final class WeatherViewModelTests: XCTestCase {

    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit
    @AppStorage(AppSettings.unitsSpeed.rawValue) var speedUnitsSetting: SpeedUnits = .mph
    @AppStorage(AppSettings.unitsPressure.rawValue) var pressureUnitsSetting: PressureUnits = .inchesHg

    var cancellables = Set<AnyCancellable>()

    var data = Data()
    override func setUpWithError() throws {
        let path = Bundle(for: WeatherViewModelTests.self).path(forResource: "Forecast3Days", ofType: "json")!
        data = NSData(contentsOfFile: path)! as Data
        weatherApiKey = "abcd1234"
        tempUnitsSetting = .fahrenheit
        speedUnitsSetting = .mph
        pressureUnitsSetting = .inchesHg
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCurrentAndForecast() {
        let viewModel = WeatherViewModel(NetworkLayerMock(jsonData: data))

        let expectation = XCTestExpectation(description: "Fulfill when we reach empty, failure or success")
        viewModel.$state.sink { [weak self] state in
            switch state {
            case .startup:
                break
            case .empty:
                XCTFail("State should not be empty")
                expectation.fulfill()
            case .loading:
                break
            case .success:
                self?.validateViewModelFields(viewModel: viewModel)
                expectation.fulfill()
            case .failure:
                XCTFail("State is failure with error: \(viewModel.getErrorMessage())")
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)

        viewModel.locationQuery = "Dallas"
        viewModel.getCurrentAndForecastWeather()

        wait(for: [expectation], timeout: 1)
    }

    func validateViewModelFields(viewModel: WeatherViewModel) {
        XCTAssertEqual(viewModel.locationName, "Highland Park, Texas")
        XCTAssertEqual(viewModel.tempString, "54°")
        XCTAssertEqual(viewModel.conditionsIconUrl?.absoluteString,
                       "https://cdn.weatherapi.com/weather/64x64/day/122.png")
        XCTAssertEqual(viewModel.condition, "Overcast")
        XCTAssertEqual(viewModel.feelsLike, "Feels like 49.9°")
        XCTAssertEqual(viewModel.humidity, "88%")
        XCTAssertEqual(viewModel.pressure, "29.94 inHg")
        XCTAssertTrue(viewModel.hasAlerts)
        XCTAssertEqual(viewModel.alertsList.count, 4)

        let forecastDays = viewModel.forecastDays()
        XCTAssertEqual(forecastDays.count, 3)
        if let forecastDayOne = forecastDays.first {
            XCTAssertEqual(forecastDayOne.highTemp, 53.8)
            XCTAssertEqual(forecastDayOne.lowTemp, 44.4)
            XCTAssertEqual(forecastDayOne.hours.count, 26)
//            XCTAssertEqual(forecastDayOne.hours[0].time, "12AM")
//            XCTAssertEqual(forecastDayOne.hours[1].time, "1AM")
//            XCTAssertEqual(forecastDayOne.hours[2].time, "2AM")
//            XCTAssertEqual(forecastDayOne.hours[3].time, "3AM")
//            XCTAssertEqual(forecastDayOne.hours[4].time, "4AM")
//            XCTAssertEqual(forecastDayOne.hours[5].time, "5AM")
//            XCTAssertEqual(forecastDayOne.hours[6].time, "6AM")
//            XCTAssertEqual(forecastDayOne.hours[7].time, "7AM")
//            XCTAssertEqual(forecastDayOne.hours[8].time, "7:29AM", "Sunrise should be at index 8")
//            XCTAssertEqual(forecastDayOne.hours[9].time, "8AM")
//            XCTAssertEqual(forecastDayOne.hours[10].time, "9AM")
//            XCTAssertEqual(forecastDayOne.hours[11].time, "10AM")
//            XCTAssertEqual(forecastDayOne.hours[12].time, "11AM")
//            XCTAssertEqual(forecastDayOne.hours[13].time, "12PM")
//            XCTAssertEqual(forecastDayOne.hours[14].time, "1PM")
//            XCTAssertEqual(forecastDayOne.hours[15].time, "2PM")
//            XCTAssertEqual(forecastDayOne.hours[16].time, "3PM")
//            XCTAssertEqual(forecastDayOne.hours[17].time, "4PM")
//            XCTAssertEqual(forecastDayOne.hours[18].time, "5PM")
//            XCTAssertEqual(forecastDayOne.hours[19].time, "5:30PM", "Sunset should be at index 19")
//            XCTAssertEqual(forecastDayOne.hours[20].time, "6PM")
//            XCTAssertEqual(forecastDayOne.hours[21].time, "7PM")
//            XCTAssertEqual(forecastDayOne.hours[22].time, "8PM")
//            XCTAssertEqual(forecastDayOne.hours[23].time, "9PM")
//            XCTAssertEqual(forecastDayOne.hours[24].time, "10PM")
//            XCTAssertEqual(forecastDayOne.hours[25].time, "11PM")
        } else {
            XCTFail("Could not get first forecast day. There should be 3.")
        }
    }
}
