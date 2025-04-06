//
//  AlertsViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 4/6/25.
//

import SwiftUI

final class AlertsViewModel: ObservableObject {
    @Published var selectedAlertIndex: Int
    private let allAlerts: WeatherDataAlerts

    private var alert: WeatherDataAlert {
        allAlerts.alerts[selectedAlertIndex]
    }

    init(allAlerts: WeatherDataAlerts, selectedAlertId: UUID) {
        self.allAlerts = allAlerts
        _selectedAlertIndex = .init(initialValue: allAlerts.alerts.firstIndex(where: { $0.id == selectedAlertId }) ?? 0)
    }

    func selectAlert(id: UUID) {
        guard hasAlerts else { return }
        selectedAlertIndex = allAlerts.alerts.firstIndex(where: { $0.id == id }) ?? 0
    }

    func nextAlert() {
        if selectedAlertIndex + 1 < allAlerts.alerts.count {
            selectedAlertIndex += 1
        }
    }

    func previousAlert() {
        if selectedAlertIndex > 0 {
            selectedAlertIndex -= 1
        }
    }

    var hasAlerts: Bool {
        allAlerts.alerts.count > 0
    }

    var navigationTitle: String {
        String(localized: "alert \(selectedAlertIndex + 1) of \(allAlerts.alerts.count)")
    }

    var messageType: String {
        alert.msgtype ?? ""
    }

    var severity: String {
        alert.severity ?? ""
    }

    var urgency: String {
        alert.urgency ?? ""
    }

    var certainty: String {
        alert.certainty ?? ""
    }

    var event: String {
        alert.event ?? ""
    }

    var headline: String {
        alert.headline ?? ""
    }

    var areas: String {
        alert.areas ?? ""
    }

    var detailedDescription: String {
        alert.desc ?? ""
    }

    var note: String {
        alert.note ?? ""
    }

    var hasNote: Bool {
        !note.isEmpty
    }

    var instructions: String {
        alert.instruction ?? ""
    }

    var alertColor: Color {
        alert.level.color
    }
}
