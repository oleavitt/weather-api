//
//  WeatherDataAlerts.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 4/6/25.
//

import Foundation

/// App's data model representing all alerts received
struct WeatherDataAlerts {
    let alerts: [WeatherDataAlert]
}

/// App's data model representing the details of a specific alert
struct WeatherDataAlert: Identifiable {
    let id: UUID
    let category: String?
    let msgtype: String?
    let note: String?
    let headline: String?
    let effective: String?
    let event: String?
    let expires: String?
    let desc: String?
    let instruction: String?
    let urgency: String?
    let severity: String?
    let areas: String?
    let certainty: String?

    var level: AlertLevel {
        AlertLevel(rawValue: severity?.lowercased() ?? "minor") ?? .minor
    }
}
