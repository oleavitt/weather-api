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
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Text(date)
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 30))
                        .foregroundStyle(.primary)
                    BasicCachedAsyncImage(url: day.conditionIconURL)
                        .frame(width: 64, height: 1)
                    hiloView
                    VStack {
                        Text("precip")
                        Text("\(day.chanceOfPrecip)%")
                    }
                    .padding(.leading)
                    if day.chanceOfSnow > 0 {
                        VStack {
                            Text("snow")
                            Text("\(day.chanceOfSnow)%")
                        }
                        .padding(.leading)
                    }
                    Spacer()
                }
                Text(day.condition)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .accessibilityElement()
            .accessibilityLabel(day.a11yLabel)
            .accessibilityHint(day.a11yDaySummary)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(day.hours, id: \.self) { hour in
                        forecastHourView(hour: hour)
                            .padding(.bottom, 4)
                            .accessibilityElement()
                            .accessibilityLabel(hour.a11yLabel)
                            .accessibilityHint(hour.a11yHourSummary)
                    }
                }
            }
        }
        .cardStyle()
    }

    private var hiloView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "arrowtriangle.up.fill")
                    .resizable()
                    .frame(width: 6, height: 6)
                    .padding(.trailing, 4)
                Text(day.highTemp.formatted() + "°")
                    .font(.custom(
                        currentTheme.fontFamily, fixedSize: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(.high)
            }
            HStack(spacing: 0) {
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 6, height: 6)
                    .padding(.trailing, 4)
                Text(day.lowTemp.formatted() + "°")
                    .font(.custom(
                        currentTheme.fontFamily, fixedSize: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(.low)
            }
        }
    }

    private func forecastHourView(hour: ForecastHour) -> some View {
        VStack {
            Text(hour.displayTime)
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 12))
            if let sunRiseSetImageName = hour.sunRiseSetImage {
                // Insert the sunrise and sunset times
                Image(systemName: sunRiseSetImageName)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.gray, .yellow, .yellow)
                    .frame(width: 36, height: 36)
                Spacer()
                Text(hour.isSunset ? "sunset" : "sunrise")
                    .font(.custom(
                        currentTheme.fontFamily, fixedSize: 12))
                    .foregroundStyle(.secondary)
            } else {
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
    }

    private var date: String {
        guard let date = day.date else { return "--" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

// swiftlint:disable line_length
#Preview {
    let hourFormatter = DateFormatter()

    let mockDay = ForcastDayViewModel(epoch: 1733100385,
                                      date: Date(),
                                      highTemp: 70,
                                      lowTemp: 58.1,
                                      conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/day/113.png"),
                                      condition: "Sunny",
                                      chanceOfPrecip: 0,
                                      chanceOfSnow: 5,
                                      hours: [
                                        ForecastHour(epoch: 1733032800,
                                                     time: hourFormatter.date(from: "12am"),
                                                     temp: 65.1,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/night/113.png"),
                                                     condition: "Sunny",
                                                     chanceOfPrecip: 0),
                                        ForecastHour(epoch: 1733036400,
                                                     time: hourFormatter.date(from: "1am"),
                                                     temp: 66.2,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/night/113.png"),
                                                     condition: "Sunny",
                                                     chanceOfPrecip: 0),
                                        ForecastHour(epoch: 1733036400,
                                                     time: hourFormatter.date(from: "1:45am"),
                                                     temp: 0,
                                                     conditionIconURL: nil,
                                                     condition: "Sunny",
                                                     chanceOfPrecip: 0,
                                                     sunRiseSetImage: "sunrise.fill"),
                                        ForecastHour(epoch: 1733040000,
                                                     time: hourFormatter.date(from: "2am"),
                                                     temp: 67.5,
                                                     conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/day/113.png"),
                                                     condition: "Sunny",
                                                     chanceOfPrecip: 0),
                                        ForecastHour(epoch: 1733036400,
                                                     time: hourFormatter.date(from: "3:45am"),
                                                     temp: 0,
                                                     conditionIconURL: nil,
                                                     condition: "Sunny",
                                                     chanceOfPrecip: 0,
                                                     sunRiseSetImage: "sunset.fill",
                                                     isSunset: true)
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
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    .foregroundColor(.white)
}
// swiftlint:enable line_length
