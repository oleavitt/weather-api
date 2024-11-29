//
//  WeatherApiView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI

struct WeatherApiView: View {
    
    @StateObject var viewModel = CurrentViewModel(NetworkLayerImpl())

    var body: some View {
        NavigationStack {
            TabView {
                CurrentView(viewModel: viewModel)
                    .tabItem {
                        Label("here-and-now", systemImage: "house")
                    }
                ForecastView()
                    .tabItem {
                        Label("forecast", systemImage: "clock")
                    }
                MapView()
                    .tabItem {
                        Label("map", systemImage: "mappin.and.ellipse")
                    }
                SettingsView()
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
            }
//            .searchable(text: $viewModel.locationQuery, prompt: "search_location")
//            .onSubmit(of: .search) {
//                Task {
//                    await viewModel.getCurrentWeather()
//                }
//            }
        }
    }
}
