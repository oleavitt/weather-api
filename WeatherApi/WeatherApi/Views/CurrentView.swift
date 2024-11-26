//
//  CurrentView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/22/24.
//

import SwiftUI

struct CurrentView: View {
    
    @ObservedObject var viewModel: CurrentViewModel
    
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
        .onAppear {
            Task {
                await viewModel.getCurrentWeather()
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
        VStack {
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
            Text(viewModel.windSummary)
            Spacer()
        }
        .background {
            let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
            LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .fontWeight(.light)
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
