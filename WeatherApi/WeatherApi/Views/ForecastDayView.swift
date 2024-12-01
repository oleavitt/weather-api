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
                CachedAsyncImage(url: day.conditionIconURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                    default:
                        placeHolderImage
                    }
                }
                .frame(width: 64, height: 64)
                VStack {
                    Text(day.hi.formatted() + "°")
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 14))
                        .foregroundColor(.red)
                    Text(day.lo.formatted() + "°")
                        .font(.custom(
                            currentTheme.fontFamily, fixedSize: 14))
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, maxHeight: 120)
        .background {
            currentTheme.backgroundColor
        }
        .cornerRadius(16)
    }
    
    var placeHolderImage: some View {
        Image(systemName: "photo")
            .font(.title)
            .foregroundStyle(.placeholder)
    }

    private var date: String {
        guard let date = day.date else { return "--" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    let mockDay = ForcastDayViewModel(date: Date(),
                                      hi: 70.5,
                                      lo: 58.1,
                                      conditionIconURL: URL.httpsURL("/cdn.weatherapi.com/weather/64x64/day/113.png"))
    VStack {
        ForecastDayView(day: mockDay)
            .padding()
        Spacer()
    }
    .background {
        let colors: [Color] = [.blue, .white]
//        let colors: [Color] = [.black, .blue]
        LinearGradient(gradient: Gradient(colors:colors), startPoint: .top, endPoint: .bottom)
    }
    .foregroundColor(.white)
}
