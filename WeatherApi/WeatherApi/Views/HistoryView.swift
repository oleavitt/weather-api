//
//  HistoryView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/29/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {

    // TODO: Need to serparate database concerns out of View to an MVVM friendly container
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
                ForEach(history, id: \.self) { item in
                    CurrentWeatherSummaryCell(data: item)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                itemToDelete = item
                                showConfirmDelete.toggle()
                            } label: {
                                Label("delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }
                        }
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
    NavigationStack {
        HistoryView()
            .modelContainer(for: CurrentWeatherModel.self) { result in
                switch result {
                case .success(let container):
                    // Load up the model with some mock content
                    let context = container.mainContext
                    try? context.delete(model: CurrentWeatherModel.self)
                    context.insert(CurrentWeatherModel(location: "Dallas, Texas",
                                                       dateTime: Date(),
                                                       tempC: 15.5, tempF: 65.4,
                                                       icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                                                       code: 1000,
                                                       uv: 3, isDay: true))
                    context.insert(CurrentWeatherModel(location: "Dallas, Texas",
                                                       dateTime: Date() + 900,
                                                       tempC: 14.5, tempF: 64.1,
                                                       icon: "//cdn.weatherapi.com/weather/64x64/day/296.png",
                                                       code: 1000,
                                                       uv: 3, isDay: true))
                    context.insert(CurrentWeatherModel(location: "Dallas, Texas",
                                                       dateTime: Date() + 1800,
                                                       tempC: 10.5, tempF: 55,
                                                       icon: "//cdn.weatherapi.com/weather/64x64/night/116.png",
                                                       code: 1000,
                                                       uv: 3, isDay: false))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
