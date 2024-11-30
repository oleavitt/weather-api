//
//  CurrentView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI

struct CurrentView: View {
    
    @ObservedObject var viewModel: CurrentViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
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
            .onAppear {
                locationManager.requestLocation() {
                    viewModel.locationQuery = locationManager.locationString ?? "auto:ip"
                    Task {
                        await viewModel.getCurrentWeather()
                    }
                }
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
            Spacer()
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
        }
    }
    
    func currentView(current: ApiCurrent) -> some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    if let location = locationManager.location {
                        Text("Your location: \(location.latitude), \(location.longitude)")
                    }
                    CachedAsyncImage(url: viewModel.conditionsIconUrl) { phase in
                        switch phase {
                        case .success(let image):
                            image
                        default:
                            placeHolderImage
                        }
                    }
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
                    windsView
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

    var windsView: some View {
        ScrollView(.horizontal) {
            HStack {
                DetailChip("wind", viewModel.windSummary)
                DetailChip("gusts", viewModel.gustsSummary)
            }
            .padding()
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
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(viewModel.tempString)
                .font(.system(size: 80))
                .fontWeight(.ultraLight)
        }
    }
    
    var placeHolderImage: some View {
        Image(systemName: "photo")
            .font(.title)
            .foregroundStyle(.placeholder)
    }
}

#Preview {
    let viewModel = CurrentViewModel(NetworkLayerMock())
    
    CurrentView(viewModel: viewModel)
        .onAppear {
            viewModel.locationQuery = "Dallas"
            viewModel.showAirQuality = true
            viewModel.showFahrenheit = true
        }
}
