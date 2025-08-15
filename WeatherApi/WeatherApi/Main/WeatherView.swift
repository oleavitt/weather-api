//
//  WeatherView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI
import SwiftData

/// This view represents both the "Current" and "Forecast" view tabs in the app
struct WeatherView: View {

    @State var isForecast: Bool

    @EnvironmentObject var viewModel: WeatherViewModel
    @State var locationManager = LocationManager()

    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context

    @Query(
        sort: \HistoryItemModel.dateTime
    ) var history: [HistoryItemModel]

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .startup:
                    loadingView
                case .empty:
                    emptyView
                case .loading:
                    loadingView
                case .success:
                    if isForecast {
                        ForecastView()
                    } else {
                        CurrentView(locationManager: locationManager)
                    }
                case .failure:
                    errorView
                }
            }
            .navigationTitle(isForecast ? "forecast" : "current")
            .searchable(text: $viewModel.locationQuery, prompt: "search-prompt")
            .onSubmit(of: .search, {
                viewModel.isUserLocation = false
                viewModel.loadData()
            })
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    // Refresh when app becomes active
                    viewModel.reloadData(locationManager: locationManager)
                }
            }
            .onChange(of: viewModel.isLoaded) {
                if viewModel.isLoaded {
                    // Save a history entry when a new current weather update is loaded
                    saveToHistory()
                }
            }
            .onAppear {
                viewModel.reloadData(locationManager: locationManager)
            }
        }
    }
}

// MARK: - Private

/// Helpers for loading data from location or search, and saving to History
private extension WeatherView {
    /// Content shown while data is loading.
    var loadingView: some View {
        VStack {
            ProgressView {
                Text("loading-one-moment-please")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Content shown when there is an error.
    var errorView: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text(viewModel.getErrorMessage())
            }
            .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement()
        .accessibilityLabel("error: \(viewModel.getErrorMessage())")
    }

    /// Content shown when there is nothing to show.
    var emptyView: some View {
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
        .accessibilityElement()
        .accessibilityLabel("empty-search-message")
    }

    /// Save a summary of the the current weather to the History list
    func saveToHistory() {
        let current = viewModel.historyItemModel()

        if !history.contains(where: {
            $0.dateTime == current.dateTime &&
            $0.location == current.location
        }) {
            context.insert(viewModel.historyItemModel())
#if DEBUG
            print("History saved for epoch: \(current.dateTime)")
            print("History count: \(history.count)")
#endif
        }
    }
}
