//
//  CurrentWeatherSummaryCell.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/28/24.
//

import SwiftUI

struct CurrentWeatherSummaryCell: View {
    @State var data: CurrentWeatherModel
    var body: some View {
        VStack(spacing: 0) {
            Text(data.location)
                .font(.system(size: 24))
                .fontWeight(.light)
            HStack {
                VStack(alignment: .leading) {
                    Text(date)
                    Text(time)
                }
                BasicCachedAsyncImage(url: URL.httpsURL(data.icon))
                    .frame(width: 64, height: 64)
                Text("\(data.tempF.formatted())°")
                    .font(.system(size: 60))
                    .fontWeight(.ultraLight)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .background {
            data.isDay ? Color.blue : Color.black
        }
        .cornerRadius(currentTheme.cornerRadius)
    }
}

private extension CurrentWeatherSummaryCell {
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: data.dateTime)
    }
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"
        return timeFormatter.string(from: data.dateTime).lowercased()
    }
}

#Preview {
    ScrollView {
        CurrentWeatherSummaryCell(data: CurrentWeatherModel(
            location: "Dallas, Texas",
            epochUpdated: 1234,
            dateTime: Date(),
            tempC: 17.8,
            tempF: 64,
            icon: "//cdn.weatherapi.com/weather/64x64/night/119.png",
            isDay: false))
        CurrentWeatherSummaryCell(data: CurrentWeatherModel(
            location: "Dallas, Texas",                                               epochUpdated: 1234,
            dateTime: Date(),
            tempC: 17.8,
            tempF: 67.6,
            icon: "//cdn.weatherapi.com/weather/64x64/day/200.png",
            isDay: true))
        Spacer()
    }
    .padding()
}
