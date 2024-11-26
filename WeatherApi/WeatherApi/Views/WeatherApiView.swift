//
//  WeatherApiView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI

struct WeatherApiView: View {
    
    @StateObject var currentViewModel = CurrentViewModel(NetworkLayerImpl())
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            TabView {
                CurrentView(viewModel: currentViewModel)
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
            .onAppear {
                locationManager.requestAuthorization()
            }
        }
        .environmentObject(locationManager)
        .searchable(text: $currentViewModel.locationQuery, prompt: "search_location")
        .onSubmit(of: .search) {
            Task {
                await currentViewModel.getCurrentWeather()
            }
        }
    }
}
