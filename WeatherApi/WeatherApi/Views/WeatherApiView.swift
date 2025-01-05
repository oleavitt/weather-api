//
//  WeatherApiView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI
import SwiftData

struct WeatherApiView: View {
    
    @StateObject var viewModel = WeatherViewModel(NetworkLayerImpl())
    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""
    
    enum TabSelection: Int {
        case current
        case forecast
        case history
        case settings
    }
    
    @State private var tabSelection: TabSelection = .current
    
    var body: some View {
        TabView(selection: $tabSelection) {
            WeatherView(isForecast: false)
                .tag(TabSelection.current)
                .tabItem {
                    Label("here-and-now", systemImage: "house")
                }
            WeatherView(isForecast: true)
                .tag(TabSelection.forecast)
                .tabItem {
                    Label("forecast", systemImage: "clock")
                }
            HistoryView()
                .tag(TabSelection.history)
                .tabItem {
                    Label("history", systemImage: "list.bullet")
                }
//            MapView()
//                .tabItem {
//                    Label("map", systemImage: "mappin.and.ellipse")
//                }
            SettingsView()
                .tag(TabSelection.settings)
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
        }
        .environmentObject(viewModel)
        .modelContainer(for: CurrentWeatherModel.self)
        .onAppear {
            if weatherApiKey.isEmpty {
                tabSelection = .settings
            }
        }
    }
}
