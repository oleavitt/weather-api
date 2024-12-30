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
        sort: \CurrentWeatherModel.dateTime,
        order: .reverse
    ) var history: [CurrentWeatherModel]

    @State var showConfirmDelete = false
    @State var itemToDelete: CurrentWeatherModel?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(history) { item in
                    CurrentWeatherSummaryCell(data: item)
                        .listRowSeparator(.hidden)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                itemToDelete = item
                                showConfirmDelete.toggle()
                            } label: {
                                Label("delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }
            }
            .navigationTitle("history")
            .confirmationDialog("delete-this-item",
                                isPresented: $showConfirmDelete,
                                titleVisibility: .visible,
                                actions: {
                Button(role: .destructive) {
                    deleteItem()
                } label: {
                    Label("delete", systemImage: "trash")
                        .symbolVariant(.fill)
                }
            })
        }
    }
}

private extension HistoryView {
    
    func deleteItem() {
        if let itemToDelete {
            context.delete(itemToDelete)
        }
        itemToDelete = nil
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
