//
//  AssetTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 4/3/25.
//

import XCTest

final class AssetTests: XCTestCase {
    func testColorsExist() {
        let allColors = ["cellBackground", "high", "low", "alert-severe", "alert-moderate", "alert-minor"]

        for color in allColors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }
}
