//
//  CurrentViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

class CurrentViewModel: ObservableObject {
    
    @Published var state: LoadingState<ApiCurrent> = .empty
    
    var locationQuery = ""
    var showAirQuality = false

    let networkLayer = NetworkLayer()

    @MainActor
    func getCurrentWeather() async {
        guard let request = Endpoint.current(query: locationQuery,
                                             aqi: showAirQuality).request else {
            return
        }

        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: ApiCurrent.self)
            state = .success(current)
        } catch {
            state = .failure(error)
            print(error)
        }
    }
}
