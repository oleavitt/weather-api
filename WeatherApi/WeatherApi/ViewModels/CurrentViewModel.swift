//
//  CurrentViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

class CurrentViewModel: ObservableObject {
    
    @Published var currentWeather: ApiCurrent?
    
    enum State {
        case empty, loading, loaded, error
    }
    
    @Published var state: State = .empty
    
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
            currentWeather = try await networkLayer.fetchJsonData(request: request, type: ApiCurrent.self)
            state = .loaded
        } catch {
            state = .error
            print(error)
        }
    }
}
