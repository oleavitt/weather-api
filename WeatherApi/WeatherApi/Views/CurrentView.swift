//
//  CurrentView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI

struct CurrentView: View {
    
    @StateObject var viewModel: CurrentViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .empty:
                emptyView()
            case .loading:
                loadingView()
            case .success(let current):
                currentView(current: current)
            case .failure(let error):
                errorView(error: error)
            }
        }
        .task {
            await viewModel.getCurrentWeather()
        }
    }
    
    func emptyView() -> some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                Text("empty-search-message")
            }
            Spacer()
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
        }
    }
    
    func currentView(current: ApiCurrent) -> some View {
        VStack {
            HStack {
                Text(current.location?.name ?? "--")
            }
            .frame(maxWidth: .infinity)
            temperatureView(current: current)
            Spacer()
        }
    }

    func errorView(error: Error) -> some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text(error.localizedDescription)
            }
            Spacer()
        }
    }
    
    func temperatureView(current: ApiCurrent) -> some View {
        HStack {
            if let temp = current.current?.tempF {
                Text(temp.formatted() + String(localized: "deg_f"))
            }
        }
    }
}

#Preview {
    let viewModel = CurrentViewModel(NetworkLayerMock())
    
    CurrentView(viewModel: viewModel)
        .onAppear {
            viewModel.locationQuery = "Dallas"
            viewModel.showAirQuality = true
        }
}
