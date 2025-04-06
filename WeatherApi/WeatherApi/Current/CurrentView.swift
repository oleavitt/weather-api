//
//  CurrentView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 3/11/25.
//

import SwiftUI
import CoreLocationUI

/// Sub view content shown when Current tab is selected.
struct CurrentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("time-last-updated \(viewModel.timeLastUpdatedFormatted)")
                    LocationButton(.currentLocation) {
                        viewModel.loadDataFromLocation(locationManager: locationManager)
                    }
                    .symbolVariant(.fill)
                    .labelStyle(.iconOnly)
                    .clipShape(.capsule)
                }
                if viewModel.hasAlerts {
                    alertsView
                }
                BasicCachedAsyncImage(url: viewModel.conditionsIconUrl)
                    .accessibilityLabel(viewModel.condition)
                HStack {
                    Text(viewModel.locationName)
                        .font(.system(size: 24))
                        .fontWeight(.light)
                    if viewModel.isUserLocation {
                        Image(systemName: "location.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .accessibilityHint(viewModel.isUserLocation ? "a11y-this-is-your-current-location" : "")

                temperatureView
                HStack {
                    Text(viewModel.condition)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
                .padding(.bottom)
                Text(viewModel.feelsLike)
                detailsView
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

// MARK: - Private

private extension CurrentView {
    /// Alerts indicator view
    var alertsView: some View {
        VStack {
            ForEach(viewModel.alerts) { alert in
                Button {
                    print("Alerts selected: Show alert details")
                } label: {
                    Label("Alert: \(alert.event ?? "")", systemImage: "exclamationmark.triangle.fill")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 4)
                .background(Color.red)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
    }

    /// Temperature subview
    var temperatureView: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(viewModel.tempString)
                .font(.system(size: 80))
                .fontWeight(.ultraLight)
        }
    }

    /// Details subviews
    var detailsView: some View {
        VStack {
            HStack {
                DetailChip("humidity", viewModel.humidity, a11yLabel: "humidity \(viewModel.humidity)")
                DetailChip("uv", viewModel.uvIndex, a11yLabel: "uv-index \(viewModel.uvIndex)")
                DetailChip("pressure", viewModel.pressure, a11yLabel: "pressure \(viewModel.pressure)")
            }
            WindView(viewModel: WindViewModel(windModel: viewModel.windModel))
        }
        .padding([.horizontal, .top])
    }
}

// MARK: - Preview

#Preview {
    CurrentView(locationManager: LocationManager())
}
