//
//  WeatherViewModelTests.swift
//  WeatherApiTests
//
//  Created by Oren Leavitt on 10/23/24.
//

import XCTest
import SwiftUI
@testable import WeatherApi

final class AlertsViewModelTests: XCTestCase {
    let testData = WeatherDataAlerts.sample
    func testProperties() {
        let viewModel = AlertsViewModel(allAlerts: testData,
                                        selectedAlertId: testData.alerts[0].id)

        XCTAssertTrue(viewModel.hasAlerts)

        XCTAssertEqual(viewModel.messageType, "Alert")
        XCTAssertEqual(viewModel.severity, "Severe")
        XCTAssertEqual(viewModel.urgency, "Expected")
        XCTAssertEqual(viewModel.certainty, "Likely")
        XCTAssertEqual(viewModel.areas, "Dallas, TX")
        XCTAssertEqual(viewModel.event, "Flood Warning")

        XCTAssertFalse(viewModel.headline.isEmpty)
        XCTAssertFalse(viewModel.navigationTitle.isEmpty)
        XCTAssertFalse(viewModel.detailedDescription.isEmpty)

        XCTAssertFalse(viewModel.hasNote)
        XCTAssertTrue(viewModel.note.isEmpty)

        XCTAssertTrue(viewModel.hasInstructions)
        XCTAssertFalse(viewModel.instructions.isEmpty)

        XCTAssertEqual(viewModel.alertColor, Color("alert-severe"))
    }

    func testNextPrevious() {
        let viewModel = AlertsViewModel(allAlerts: testData,
                                        selectedAlertId: testData.alerts[1].id)

        XCTAssertEqual(viewModel.severity, "Moderate")
        XCTAssertFalse(viewModel.hasNote)
        XCTAssertTrue(viewModel.note.isEmpty)
        XCTAssertTrue(viewModel.hasInstructions)
        XCTAssertFalse(viewModel.instructions.isEmpty)

        viewModel.nextAlert()
        XCTAssertEqual(viewModel.severity, "Minor")
        XCTAssertTrue(viewModel.hasNote)
        XCTAssertFalse(viewModel.note.isEmpty)
        XCTAssertFalse(viewModel.hasInstructions)
        XCTAssertTrue(viewModel.instructions.isEmpty)

        viewModel.nextAlert()
        XCTAssertEqual(viewModel.severity, "Minor")

        viewModel.previousAlert()
        XCTAssertEqual(viewModel.severity, "Moderate")

        viewModel.previousAlert()
        XCTAssertEqual(viewModel.severity, "Severe")

        viewModel.previousAlert()
        XCTAssertEqual(viewModel.severity, "Severe")

        viewModel.nextAlert()
        XCTAssertEqual(viewModel.severity, "Moderate")
    }

    func testSelectAlert() {
        let viewModel = AlertsViewModel(allAlerts: testData,
                                        selectedAlertId: testData.alerts[0].id)

        viewModel.selectAlert(id: testData.alerts[2].id)
        XCTAssertEqual(viewModel.severity, "Minor")
    }
}
