//
//  ForecastView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 3/11/25.
//

import SwiftUI

/// Sub view content shown when Forecast tab is selected.
struct ForecastView: View {
    @EnvironmentObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.forecastDays(), id: \.self) { day in
                    ForecastDayRow(day: day)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .background {
            let colors: [Color] = viewModel.isDay ? [.blue, .white] : [.black, .blue]
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
        }
        .foregroundColor(.white)
        .font(.system(size: 18))
        .fontWeight(.light)
    }
}

// MARK: - Preview

#Preview {
    ForecastView()
}
