//
//  AlertsView.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 4/5/25.
//

import SwiftUI

/// Swipable view to alert details for each in the given alerts array
struct AlertsView: View {
    @Environment(\.dismiss) var dismiss

    init(_ selectedAlertId: UUID, alerts: [WeatherDataAlert]) {
        self.selectedAlertId = selectedAlertId
        self.alerts = alerts
    }

    private let selectedAlertId: UUID
    private let alerts: [WeatherDataAlert]
    @State private var selectedAlertIndex = 0

    private var alert: WeatherDataAlert {
        alerts[selectedAlertIndex]
    }

    var body: some View {
        let dragGesture = DragGesture()
            .onEnded { value in
                withAnimation {
                    handleSwipe(value)
                }
            }

        NavigationStack {
            VStack {
                if alerts.isEmpty {
                    Text("no-alerts")
                } else {
                    alertContent
                        .gesture(dragGesture)
                }
            }
            .padding(.horizontal)
            .onAppear {
                selectedAlertIndex = self.alerts.firstIndex(where: { $0.id == selectedAlertId }) ?? 0
            }
            .toolbar {
                Button("close", systemImage: "xmark.circle.fill") {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private var alertContent: some View {
        Text("alert \(selectedAlertIndex + 1) of \(alerts.count)")
            .fontWeight(.light)
            .foregroundStyle(.secondary)
        Divider()
        HStack {
            Text(alert.msgtype ?? "")
            Spacer()
            Text(alert.certainty ?? "")
                .frame(alignment: .trailing)
        }
        Text(alert.event ?? "")
            .fontWeight(.bold)
        Text(alert.headline ?? "")
        Divider()
        ScrollView {
            Text("areas-affected")
                .fontWeight(.bold)
            Text(alert.areas ?? "")
            Divider()
            Text("description")
                .fontWeight(.bold)
            Text(alert.desc ?? "")
            Divider()
            Text("instructions")
                .fontWeight(.bold)
            Text(alert.instruction ?? "")
        }
    }
}

// MARK: - Private

private extension AlertsView {

    func handleSwipe(_ value: DragGesture.Value) {
        if abs(value.velocity.width) < 25 { return }

        let deltaX = value.location.x - value.startLocation.x
        let deltaY = value.location.y - value.startLocation.y

        if abs(deltaY) < 30 {
            if deltaX < 150 {
                // Swipe right
                nextAlert()
            } else if deltaX > 150 {
                // Swipe left
                previousAlert()
            }
        }
    }

    func nextAlert() {
        if selectedAlertIndex + 1 < alerts.count {
            selectedAlertIndex += 1
        }
    }

    func previousAlert() {
        if selectedAlertIndex > 0 {
            selectedAlertIndex -= 1
        }
    }
}

// MARK: - Preview

#Preview {
    AlertsView(WeatherDataAlerts.sample[0].id, alerts: WeatherDataAlerts.sample)
}
