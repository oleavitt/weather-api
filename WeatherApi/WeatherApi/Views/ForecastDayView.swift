//
//  ForecastDayView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/30/24.
//

import SwiftUI

struct ForecastDayView: View {
    
    let day: ForcastDayViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(date)
                    .padding(.leading)
                BasicCachedAsyncImage(url: day.conditionIconURL)
                    .frame(width: 64, height: 64)
                VStack {
                    Text(day.hi.formatted() + "°")
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text(day.lo.formatted() + "°")
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(day.hours, id: \.self) { hour in
                        forecastHourView(hour: hour)
                    }
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .foregroundColor(.primary)
        .background {
            currentTheme.backgroundColor
        }
        .cornerRadius(currentTheme.cornerRadius)
    }

    private func forecastHourView(hour: ForecastHour) -> some View {
        VStack {
            Text(hour.time)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 12))
            CachedAsyncImage(url: hour.conditionIconURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 48, height: 48)
                default:
                    Image(systemName: "photo")
                        .foregroundStyle(.placeholder)
                }
            }
            .frame(width: 36, height: 36)
            Text(hour.temp.formatted() + "°")
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 14))
                .fontWeight(.bold)
        }
    }
    
    private var date: String {
        guard let date = day.date else { return "--" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    let mockDay = ForcastDayViewModel(epoch: 1733100385,
                                      date: Date(),
                                      hi: 70.5,
                                      lo: 58.1,
                                      conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/day/113.png"),
                                      hours: [
                                        ForecastHour(epoch: 1733032800,
                                                     time: "12am",
                                                     temp: 65.1,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/night/113.png")),
                                        ForecastHour(epoch: 1733036400,
                                                     time: "1am",
                                                     temp: 66.2,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/night/113.png")),
                                        ForecastHour(epoch: 1733040000,
                                                     time: "2am",
                                                     temp: 67.5,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/day/113.png"))
                                      ])
    VStack {
        ScrollView {
            ForecastDayView(day: mockDay)
                .padding()
        }
    }
    .background {
        let colors: [Color] = [.blue, .white]
//        let colors: [Color] = [.black, .blue]
        LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
    }
    .foregroundColor(.white)
}
