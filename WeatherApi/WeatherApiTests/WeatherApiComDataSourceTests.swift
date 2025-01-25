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
                XCTAssertEqual(dataSource.locationData?.name, "Dallas")
                XCTAssertEqual(dataSource.currentTemp(units: .celsius), 17.8)
                XCTAssertEqual(dataSource.currentTemp(units: .fahrenheit), 64)
                XCTAssertEqual(weatherData.forecast?.forecastDays.count, 3)
                
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }
    }
}
