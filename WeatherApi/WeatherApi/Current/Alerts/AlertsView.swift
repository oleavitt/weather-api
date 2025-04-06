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

    @StateObject private var viewModel: AlertsViewModel

    init(_ selectedAlertId: UUID, alerts: WeatherDataAlerts) {
        _viewModel = .init(wrappedValue: AlertsViewModel(allAlerts: alerts, selectedAlertId: selectedAlertId))
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
                if viewModel.hasAlerts {
                    alertContent
                        .gesture(dragGesture)
                } else {
                    Text("no-alerts")
                }
            }
            .padding(.horizontal)
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("close", systemImage: "xmark.circle.fill") {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private var alertContent: some View {
        HStack {
            Text(viewModel.messageType)
            Text(viewModel.severity)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(viewModel.urgency)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(viewModel.certainty)
                .frame(alignment: .trailing)
        }
        Text(viewModel.event)
            .fontWeight(.bold)
        Text(viewModel.headline)
        Divider()
        ScrollView {
            Text("areas-affected")
                .fontWeight(.bold)
            Text(viewModel.areas)
            Divider()
            Text("description")
                .fontWeight(.bold)
            Text(viewModel.detailedDescription)
            if viewModel.hasNote {
                Divider()
                Text("note")
                    .fontWeight(.bold)
                Text(viewModel.note)
            }
            Divider()
            Text("instructions")
                .fontWeight(.bold)
            Text(viewModel.instructions)
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
                viewModel.nextAlert()
            } else if deltaX > 150 {
                // Swipe left
                viewModel.previousAlert()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AlertsView(WeatherDataAlerts.sample.alerts[0].id, alerts: WeatherDataAlerts.sample)
}
