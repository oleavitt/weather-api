//
//  SettingsView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/17/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    // TODO: Need to serparate database concerns out of View to an MVVM friendly container
    @Environment(\.modelContext) var context

    @AppStorage(AppSettings.unitsTemp.rawValue) var tempUnitsSetting: TempUnits = .fahrenheit
    @AppStorage(AppSettings.unitsSpeed.rawValue) var speedUnitsSetting: SpeedUnits = .mph

    @State var showDeleteHistoryConfirm = false
    @State var showDeleteOldHistoryConfirm = false
    @State var historyHours = "30"
    @FocusState var hoursInputFocused: Bool
        
    var body: some View {
        NavigationStack {
            List {
                Section("data-source") {
                    NavigationLink(destination: ApiProviderView()) {
                        Text("api-providers")
                    }
                }
                Section("units") {
                    Picker(TempUnits.title, selection: $tempUnitsSetting) {
                        ForEach(TempUnits.allCases, id: \.self) { unit in
                            Text(unit.description).tag(unit)
                        }
                    }
                    Picker(SpeedUnits.title, selection: $speedUnitsSetting) {
                        ForEach(SpeedUnits.allCases, id: \.self) { unit in
                            Text(unit.description).tag(unit)
                        }
                    }
                }
                Section("history \(historyCount)") {
                    VStack(alignment: .leading) {
                        Button("delete-history-older-than") {
                            showDeleteOldHistoryConfirm.toggle()
                        }
                        HStack {
                            TextField("hours", text: $historyHours)
                                .keyboardType(.asciiCapableNumberPad)
                                .focused($hoursInputFocused)
                                .textFieldStyle(.roundedBorder)
                            Text("hours")
                        }
                    }
                    Button("delete-all-history") {
                        showDeleteHistoryConfirm.toggle()
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("done") {
                        hoursInputFocused = false
                    }
                }
            }
            .navigationTitle("settings")
            .alert("confirm-delete", isPresented: $showDeleteHistoryConfirm, actions: {
                Button("delete", role: .destructive) {
                    deleteAllHistory()
                }
            }, message: {
                Text("delete-all-history-confirm")
            })
            .alert("confirm-delete", isPresented: $showDeleteOldHistoryConfirm, actions: {
                Button("delete", role: .destructive) {
                    deleteOldHistory()
                }
            }, message: {
                Text("delete-old-history-confirm \(historyHours)")
            })
        }
    }
}

private extension SettingsView {
    var historyCount: Int {
        let descriptor = FetchDescriptor<CurrentWeatherModel>()
        return (try? context.fetchCount(descriptor)) ?? 0
    }
    
    func deleteAllHistory() {
        hoursInputFocused = false
        do {
            try context.delete(model: CurrentWeatherModel.self)
        } catch {
#if DEBUG
            print("Error trying to delete all History. \(error.localizedDescription)")
#endif
        }
    }
    
    func deleteOldHistory() {
        hoursInputFocused = false
        guard let maxAgeHours = Int(historyHours),
              let cutoffDate = Calendar.current.date(byAdding: .hour, value: -maxAgeHours, to: Date()) else {
            return
        }

        do {
            try context.delete(model: CurrentWeatherModel.self, where: #Predicate { $0.dateTime < cutoffDate })
        } catch {
#if DEBUG
            print("Error trying to delete old History. \(error.localizedDescription)")
#endif
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
