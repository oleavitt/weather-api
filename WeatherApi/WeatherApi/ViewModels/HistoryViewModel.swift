//
//  HistoryViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/1/25.
//

import Foundation

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var history: CurrentWeatherHistory = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @ObservationIgnored
    private let dataSource = HistoryDatabaseManager()

    func fetchHistory() async {
        isLoading = true
        let result = dataSource.fetchItems()
        isLoading = false
        switch result {
        case .success(let historyModel):
            history = historyModel
        case .failure(let error):
            #if DEBUG
            print("Error fetching history: \(error.localizedDescription)")
            #endif
            errorMessage = error.localizedDescription
        }
    }
}
