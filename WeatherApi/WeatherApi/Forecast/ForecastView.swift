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
                        .scrollTransition { content, phase in
                            // Give days a fading "roll on/off" effect as they scroll on/off screen
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.5)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.75)
                                .rotation3DEffect(.radians(phase.value), axis: (-1, 0, 0))
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

#Preview {
    ForecastView()
}
