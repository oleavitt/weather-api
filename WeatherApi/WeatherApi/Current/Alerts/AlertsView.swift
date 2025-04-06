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
        NavigationStack {
            VStack {
                if viewModel.hasAlerts {
                    alertContent
                        .gesture(DragGesture()
                            .onEnded { value in
                                withAnimation {
                                    handleSwipe(value)
                                }
                            })
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
        alertBanner
        alertEvent
        Text(viewModel.headline)
        Divider()
        ScrollView {
            alertContentSection("areas-affected", details: viewModel.areas)
            Divider()
            alertContentSection("description", details: viewModel.detailedDescription)
            if viewModel.hasNote {
                Divider()
                alertContentSection("note", details: viewModel.note)
            }
            Divider()
            alertContentSection("instructions", details: viewModel.instructions)
        }
    }

    private var alertBanner: some View {
        HStack {
            Text(viewModel.messageType)
            Text(viewModel.severity)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(viewModel.urgency)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(viewModel.certainty)
                .frame(alignment: .trailing)
        }
    }

    private var alertEvent: some View {
        Label(viewModel.event, systemImage: "exclamationmark.triangle.fill")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(viewModel.alertColor)
            .clipShape(Capsule())
            .foregroundColor(.white)
    }

    @ViewBuilder
    private func alertContentSection(_ title: LocalizedStringKey, details: String) -> some View {
        Text(title)
            .fontWeight(.bold)
        Text(details)
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
