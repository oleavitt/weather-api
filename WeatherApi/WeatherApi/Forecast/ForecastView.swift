//
//  ForecastView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 3/11/25.
//

import SwiftUI

/// Sub view content shown when Forecast tab is selected.
struct ForecastView: View {
    @Environment(WeatherViewModel.self) private var viewModel

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.forecastDays(), id: \.self) { day in
                    ForecastDayRow(day: day)
                        .padding(.horizontal)
                        .scrollTransition { content, phase in
                            // Give days a fading effect as they scroll on/off screen
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.5)
                        }
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

// #Preview {
//    ForecastView()
// }
