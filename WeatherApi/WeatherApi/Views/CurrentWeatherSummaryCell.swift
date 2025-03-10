//
//  CurrentWeatherSummaryCell.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import SwiftUI

struct CurrentWeatherSummaryCell: View {
    @StateObject private var viewModel: CurrentWeatherSummaryCellViewModel
    
    init(data: CurrentWeatherModel) {
        _viewModel = StateObject(wrappedValue: CurrentWeatherSummaryCellViewModel(data: data))
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.location)
                .font(.system(size: 24))
                .fontWeight(.light)
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.date)
                        .font(.system(size: 24))
                    Text(viewModel.time)
                        .fontWeight(.light)
                }
                .frame(maxWidth: 96, alignment: .leading)
                BasicCachedAsyncImage(url: viewModel.iconURL)
                    .frame(width: 64, height: 64)
                Text(viewModel.temperature)
                    .font(.system(size: 36))
                    .fontWeight(.ultraLight)
                    .padding(.leading)
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .background {
            viewModel.isDay ? Color.blue : Color.black
        }
        .cornerRadius(currentTheme.cornerRadius)
        .accessibilityElement()
        .accessibilityLabel(viewModel.a11yCurrentWeatherSummary)
    }
}

#Preview {
    ScrollView {
        CurrentWeatherSummaryCell(data: CurrentWeatherModel(
            location: "Dallas, Texas",
            dateTime: Date(),
            tempC: 17.8,
            tempF: 64,
            icon: "//cdn.weatherapi.com/weather/64x64/night/119.png",
            condition: "Sunny",
            code: 1000,
            uv: 0,
            isDay: false))
        CurrentWeatherSummaryCell(data:CurrentWeatherModel(
            location: "Dallas, Texas",
            dateTime: Date(),
            tempC: 17.8,
            tempF: -23,
            icon: "//cdn.weatherapi.com/weather/64x64/night/113.png",
            condition: "Sunny",
            code: 1000,
            uv: 0,
            isDay: false))
        CurrentWeatherSummaryCell(data: CurrentWeatherModel(
            location: "Dallas, Texas",
            dateTime: Date(),
            tempC: 17.8,
            tempF: 108.6,
            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
            condition: "Sunny",
            code: 1000,
            uv: 2,
            isDay: true))
        Spacer()
    }
    .padding()
}
