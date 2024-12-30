//
//  HistoryView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/29/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {

    @Environment(\.modelContext) var context
    
    @Query(
        sort: \CurrentWeatherModel.dateTime
    ) var history: [CurrentWeatherModel]

    var body: some View {
        ScrollView {
            ForEach(history) { item in
                CurrentWeatherSummaryCell(data: item)
            }
        }
        .padding()
        .navigationTitle("history")
    }
}

#Preview {
    let mockHistory = [
        CurrentWeatherModel(location: "Dallas, Texas",
                            epochUpdated: 1000,
                            dateTime: Date.now,
                            tempC: 15.5, tempF: 65.4,
                            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            code: 1000,
                            uv: 3, isDay: true),
        CurrentWeatherModel(location: "Dallas, Texas",
                            epochUpdated: 1001,
                            dateTime: Date.now + 900,
                            tempC: 15.8, tempF: 66.1,
                            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            code: 1000,
                            uv: 3, isDay: true),
        CurrentWeatherModel(location: "Dallas, Texas",
                            epochUpdated: 1002,
                            dateTime: Date.now + 1800,
                            tempC: 16.7, tempF: 68,
                            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                            code: 1000,
                            uv: 3, isDay: true)
    ]
    NavigationStack {
        HistoryView()
            .modelContainer(for: CurrentWeatherModel.self)
    }
}
