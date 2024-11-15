//
//  WeatherApiView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI

struct WeatherApiView: View {
    
    @StateObject var currentViewModel = CurrentViewModel(NetworkLayerImpl())
    
    var body: some View {
        TabView {
            CurrentView(viewModel: currentViewModel)
                .tabItem {
                    Label("current", systemImage: "cloud.sun")
                }
            DetailView()
                .tabItem {
                    Label("details", systemImage: "list.bullet.rectangle")
                }
            MapView()
                .tabItem {
                    Label("map", systemImage: "map")
                }
        }
    }
}
