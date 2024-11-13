//
//  CurrentViewModel.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation

class CurrentViewModel: ObservableObject {
    
    @Published var state: LoadingState<ApiCurrent> = .empty
    
    var locationQuery = "Dallas"
    var showAirQuality = false

    let networkLayer: NetworkLayer
    
    public init(_ networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }

    @MainActor
    func getCurrentWeather() async {
        guard let request = Endpoint.current(query: locationQuery,
                                             aqi: showAirQuality).request else {
            return
        }

        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: ApiCurrent.self)
            if let errorResponse = current.error {
                switch errorResponse.code {
                case 1003:
                    state = .failure(ApiErrorType.emptySearch)
                case 1006:
                    state = .failure(ApiErrorType.noMatch)
                default:
                    state = .failure(ApiErrorType.genericError)
                }
            } else {
                state = .success(current)
            }
        } catch {
            state = .failure(error)
            print(error)
        }
    }
}
