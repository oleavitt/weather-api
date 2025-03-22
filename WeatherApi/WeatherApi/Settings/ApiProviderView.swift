//
//  ApiProviderView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/17/24.
//

import SwiftUI

struct ApiProviderView: View {
    @State var apiKeyInput: String = ""
    @AppStorage(AppSettings.weatherApiKey.rawValue) var weatherApiKey = ""

    var body: some View {
        Form {
            Section("provider") {
                // Make this a drop-down list of APIs once multiple sources are supported
                Text("Weather API")
            }
            Section("api-key") {
                TextField("weather-api-key-placeholder", text: $apiKeyInput)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)
            }
        }
        .onAppear {
            apiKeyInput = weatherApiKey
        }
        .onDisappear {
            saveChanges()
        }
        .onSubmit(of: .text) {
            saveChanges()
        }
        .navigationTitle("api-providers")
    }

    private func saveChanges() {
        weatherApiKey = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ApiProviderView()
    }
}
