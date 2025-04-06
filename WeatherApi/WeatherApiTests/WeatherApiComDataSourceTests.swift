//
//  WeatherApiComDataSourceTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 1/21/25.
//

import XCTest
@testable import WeatherApi

final class WeatherApiComDataSourceTests: XCTestCase {

    var data = Data()
    override func setUpWithError() throws {
        let path = Bundle(for: WeatherApiComDataSourceTests.self).path(forResource: "Forecast3Days", ofType: "json")!
        data = NSData(contentsOfFile: path)! as Data
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetForecast() {
        let dataSource = WeatherApiComDataSource()

        dataSource.setup(networkLayer: NetworkLayerMock(jsonData: data), apiKey: "1234abcd")

        dataSource.getForecast(locationQuery: "Dallas", includeAqi: true) { result in
            switch result {
            case .success(let weatherData):
                XCTAssertNotNil(weatherData)
                XCTAssertEqual(dataSource.locationData?.name, "Highland Park")
                XCTAssertEqual(dataSource.currentTemp(units: .celsius), 12.2)
                XCTAssertEqual(dataSource.currentTemp(units: .fahrenheit), 54)
                XCTAssertEqual(weatherData.forecast?.forecastDays.count, 3)

                // This should have 4 alerts
                XCTAssertNotNil(dataSource.alerts)
                XCTAssertEqual(dataSource.alerts?.alerts.count, 4)

                let alert1 = dataSource.alerts?.alerts.first

                // Make sure we have some expected content in the first alert
                XCTAssertEqual(alert1?.category, "Met")
                XCTAssertEqual(alert1?.msgtype, "Alert")
                XCTAssertEqual(alert1?.note, "")
                XCTAssertEqual(alert1?.event, "Flood Warning")

            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }
    }
}
