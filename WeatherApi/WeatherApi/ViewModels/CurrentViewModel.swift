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
    
    var showAirQuality = false
    
    @MainActor
    func getCurrentWeather() async {
        guard let url = Endpoint.current(query: "Dallas",
                                         aqi: showAirQuality).url else {
            return
        }
#if DEBUG
        print(url.absoluteString)
#endif

        state = .loading
        do {
            let response = try await URLSession.shared.data(from: url)
            let data = response.0
            
#if DEBUG
            if let json = try? JSONSerialization.jsonObject(with: data),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
#endif

            let decoder = JSONDecoder()
            currentWeather = try decoder.decode(ApiCurrent.self, from: data)
            state = .loaded
        } catch {
            state = .error
            print(error)
        }
    }
}
