//
//  WeatherView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI

struct WeatherView: View {
    
    @State var isForecast: Bool

    @EnvironmentObject var viewModel: WeatherViewModel

    @StateObject var locationManager = LocationManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
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
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                loadData()
            }
        })
        .onAppear {
            loadData()
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
        GeometryReader { proxy in
            VStack {
                VStack {
                    Text("time-last-updated \(viewModel.timeLastUpdated)")
                    BasicCachedAsyncImage(url: viewModel.conditionsIconUrl)
                    HStack {
                        Text(viewModel.locationName)
                            .font(.system(size: 24))
                            .fontWeight(.light)
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
                .padding(.top, proxy.safeAreaInsets.top)
            }
            .background {
                let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
                LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
            }
            .foregroundColor(.white)
            .font(.system(size: 18))
            .fontWeight(.light)
            .ignoresSafeArea(edges: [.top, .horizontal])
        }
    }
    
    func forecastView(current: ApiModel) -> some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    CurrentWeatherSummaryCell(data: viewModel.currentWeatherModel())
                        .padding([.bottom, .horizontal])
                    forecastListView
                    Spacer()
                }
                .padding(.top, proxy.safeAreaInsets.top)
            }
            .background {
                let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
                LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
            }
            .foregroundColor(.white)
            .font(.system(size: 18))
            .fontWeight(.light)
            .ignoresSafeArea(edges: [.top, .horizontal])
        }
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
    func loadData() {
        // TODO: Update with last location saved while awaiting updated location
        locationManager.requestAuthorization() {
            locationManager.requestLocation() {
                viewModel.locationQuery = locationManager.locationString ?? "auto:ip"
                Task {
                    await viewModel.getCurrentAndForecastWeather()
                }
            }
        }
    }
}
