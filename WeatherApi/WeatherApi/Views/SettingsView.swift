//
//  SettingsView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/17/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink(destination: ApiProviderView()) {
                Text("api-providers")
            }
        }
        .navigationTitle("settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
