//
//  ApiProviderView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/17/24.
//

import SwiftUI

struct ApiProviderView: View {
    @State var apiKeyInput: String = ""
    @AppStorage("weather-api-key") var weatherApiKey = ""
    
    var body: some View {
        Form {
            Section("provider") {
                // Make this a drop-down list of APIs once multiple sources are supported
                Text("Weather API")
            }
            Section("api-key") {
                TextField("weather-api-key-placeholder", text: $apiKeyInput)
            }
        }
        .onAppear {
            apiKeyInput = weatherApiKey
        }
        .onSubmit(of: .text) {
            weatherApiKey = apiKeyInput
        }
        .navigationTitle("api-providers")
    }
}

#Preview {
    NavigationStack {
        ApiProviderView()
    }
}
