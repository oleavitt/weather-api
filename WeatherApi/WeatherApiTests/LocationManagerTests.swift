//
//  LocationManagerTests.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 8/14/25.
//

import XCTest
import CoreLocation
@testable import WeatherApi

final class LocationManagerTests: XCTestCase {

//    func testAuthorizationStatusChange() {
//        let manager = LocationManager()
//        let exp = expectation(description: "Authorization completion called")
//
//        manager.requestAuthorization {
//            exp.fulfill()
//        }
//        // Simulate delegate callback
//        manager.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)
//        XCTAssertEqual(manager.authorizationStatus, .authorizedWhenInUse)
//        wait(for: [exp], timeout: 1)
//    }

    func testLocationUpdate() {
        let manager = LocationManager()
        let exp = expectation(description: "Location completion called")
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)

        manager.requestLocation {
            exp.fulfill()
        }
        // Simulate delegate callback
        manager.locationManager(CLLocationManager(), didUpdateLocations: [testLocation])
        XCTAssertEqual(manager.location?.latitude ?? 0.0, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(manager.location?.longitude ?? 0.0, -122.4194, accuracy: 0.0001)
        wait(for: [exp], timeout: 1)
    }

    func testLocationString() {
        let manager = LocationManager()
        manager.location = CLLocationCoordinate2D(latitude: 1.23, longitude: 4.56)
        XCTAssertEqual(manager.locationString, "1.23,4.56")
    }
}
