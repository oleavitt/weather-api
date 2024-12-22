//
//  WeatherApiView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI

struct WeatherApiView: View {
    
    @StateObject var viewModel = CurrentViewModel(NetworkLayerImpl())
    @AppStorage("weather-api-key") var weatherApiKey = ""
    
    enum TabSelection: Int {
        case current
        case settings
    }
    
    @State private var tabSelection: TabSelection = .current
    
    var body: some View {
        NavigationStack {
            TabView(selection: $tabSelection) {
                CurrentView(viewModel: viewModel)
                    .tag(TabSelection.current)
                    .tabItem {
                        Label("here-and-now", systemImage: "house")
                    }
//                ForecastView()
//                    .tabItem {
//                        Label("forecast", systemImage: "clock")
//                    }
//                MapView()
//                    .tabItem {
//                        Label("map", systemImage: "mappin.and.ellipse")
//                    }
                SettingsView()
                    .tag(TabSelection.settings)
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
            }
            .onAppear {
                if weatherApiKey.isEmpty {
                    tabSelection = .settings
                }
            }
        }
    }
}
