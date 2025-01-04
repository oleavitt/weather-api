//
//  SettingsView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/17/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.modelContext) var context
    @State var showDeleteHistoryConfirm = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("data-source") {
                    NavigationLink(destination: ApiProviderView()) {
                        Text("api-providers")
                    }
                }
                Section("history") {
                    Button("delete-all-history") {
                        showDeleteHistoryConfirm.toggle()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("settings")
            .confirmationDialog("delete-all-history-confirm",
                                isPresented: $showDeleteHistoryConfirm,
                                titleVisibility: .visible) {
                Button(role: .destructive) {
                    deleteAllHistory()
                } label: {
                    Label("delete", systemImage: "trash")
                        .symbolVariant(.fill)
                }
            }
        }
    }
}

extension SettingsView {
    func deleteAllHistory() {
        do {
            try context.delete(model: CurrentWeatherModel.self)
        } catch {
#if DEBUG
            print("Error trying to delete all History. \(error.localizedDescription)")
#endif
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
