//
//  WindView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/15/25.
//

import SwiftUI

struct WindView: View {
    @StateObject var viewModel: WindViewModel
    
    var body: some View {
        VStack {
            Text("wind")
                .font(.custom(
                    currentTheme.fontFamily, fixedSize: 24))
            VStack(alignment: .leading) {
                Text(viewModel.windSummary)
                Text(viewModel.gustsSummary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cardStyle()
    }
}

#Preview {
    VStack {
        WindView(viewModel: WindViewModel(windModel: WindModel(speedKph: 8.3,
                                                               speedMph: 5.1,
                                                               degree: 159,
                                                               direction: "SSE",
                                                               gustKph: 17.4,
                                                               gustMph: 10.8)))
        .padding(.bottom, 8)
        WindView(viewModel: WindViewModel(windModel: nil))
        Spacer()
    }
    .padding()
}
