//
//  WeatherView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI
import SwiftData
import CoreLocationUI

struct WeatherView: View {
    
    @State var isForecast: Bool

    @EnvironmentObject var viewModel: WeatherViewModel

    @StateObject var locationManager = LocationManager()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context

    @Query(
        sort: \CurrentWeatherModel.dateTime
    ) var history: [CurrentWeatherModel]
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .startup:
                    loadingView()
                case .empty:
                    emptyView()
                case .loading:
                    loadingView()
                case .success(let current):
                    if isForecast {
                        forecastView(current: current)
                    } else {
                        currentView(current: current)
                    }
                case .failure(let error):
                    errorView(error: error)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isForecast ? "forecast" : "current")
            .searchable(text: $viewModel.locationQuery, prompt: "search-prompt")
            .onSubmit(of: .search, {
                viewModel.isSearchQuery = true
                loadData()
            })
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    // Refresh when app becomes active
                    reloadData()
                }
            }
            .onChange(of: viewModel.isLoaded) {
                if viewModel.isLoaded {
                    // Save a history entry when a new current weather update is loaded
                    saveToHistory()
                }
            }
            .onAppear {
                reloadData()
            }
        }
    }
    
    func emptyView() -> some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                Text("empty-search-message")
            }
            .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView() {
                Text("loading-one-moment-please")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func currentView(current: ApiModel) -> some View {
        VStack {
            VStack {
                HStack {
                    Text("time-last-updated \(viewModel.timeLastUpdated)")
                    LocationButton(.currentLocation) {
                        loadDataFromLocation()
                    }
                    .symbolVariant(.fill)
                    .labelStyle(.iconOnly)
                    .clipShape(.capsule)
                }
                BasicCachedAsyncImage(url: viewModel.conditionsIconUrl)
                HStack {
                    Text(viewModel.locationName)
                        .font(.system(size: 24))
                        .fontWeight(.light)
                    if !viewModel.isSearchQuery {
                        Image(systemName: "location.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                temperatureView(current: current)
                HStack {
                    Text(viewModel.condition)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
                .padding(.bottom)
                Text(viewModel.feelsLike)
                detailsView
                Spacer()
            }
            .padding(.top)
        }
        .background {
            let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
            LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .fontWeight(.light)
    }
    
    func forecastView(current: ApiModel) -> some View {
        VStack {
            VStack {
                CurrentWeatherSummaryCell(data: viewModel.currentWeatherModel())
                    .padding([.bottom, .horizontal])
                forecastListView
                Spacer()
            }
            .padding(.top)
        }
        .background {
            let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
            LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .fontWeight(.light)
    }

    var detailsView: some View {
        ScrollView(.horizontal) {
            HStack {
                DetailChip("wind", viewModel.windSummary)
                DetailChip("gusts", viewModel.gustsSummary)
                DetailChip("humidity", viewModel.humidity)
                DetailChip("uv", viewModel.uvIndex)
            }
            .padding()
        }
    }
    
    var forecastListView: some View {
        ScrollView {
            ForEach(viewModel.forecastDays(), id: \.self) { day in
                ForecastDayView(day: day)
                    .padding(.horizontal)
            }
        }
    }
    
    func errorView(error: Error) -> some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text(error.localizedDescription)
            }
            .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func temperatureView(current: ApiModel) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(viewModel.tempString)
                .font(.system(size: 80))
                .fontWeight(.ultraLight)
        }
    }
}

private extension WeatherView {
    func loadDataFromLocation() {
        locationManager.requestAuthorization() {
            locationManager.requestLocation() {
                viewModel.isSearchQuery = false
                viewModel.locationQuery = locationManager.locationString ?? "auto:ip"
                loadData()
            }
        }
    }
    
    func reloadData() {
        if viewModel.isSearchQuery && !viewModel.locationQuery.isEmpty {
            loadData()
        } else {
            loadDataFromLocation()
        }
    }
    
    func loadData() {
        Task {
            await viewModel.getCurrentAndForecastWeather()
        }
    }

    func saveToHistory() {
        let current = viewModel.currentWeatherModel()
#if DEBUG
        print("History count: \(history.count)")
#endif
        if !history.contains(where: {
            $0.epochUpdated == current.epochUpdated &&
            $0.location == current.location
           }) {
            context.insert(viewModel.currentWeatherModel())
#if DEBUG
            print("History saved for epoch: \(current.epochUpdated)")
#endif
        }
    }
}
