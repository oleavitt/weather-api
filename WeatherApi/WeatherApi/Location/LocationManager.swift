//
//  LocationManager.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI
import CoreLocation

/// An interface to CoreLocation for authorization and querying location.
/// This handles the delegation and returns results via completion handlers.
@Observable
class LocationManager: NSObject {

    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var location: CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()
    private var completion: (() -> Void)?
    private var authReqCompletion: (() -> Void)?

    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.delegate = self
    }

    /// Get location and return result in a completion block.
    func requestLocation(completion: @escaping () -> Void) {
        self.completion = completion
        locationManager.requestLocation()
    }

    /// Request authorization and return result in a completion block.
    public func requestAuthorization(always: Bool = false, completion: @escaping () -> Void) {
        self.authReqCompletion = completion

        switch locationManager.authorizationStatus {

        case .authorizedAlways, .authorizedWhenInUse:
            completion()
            return

        default:
            if always {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    /// The last queried location as a string in "lat, long" format.
    /// Nil is returned if no location is available.
    var locationString: String? {
        if let location {
            return "\(location.latitude.formatted()),\(location.longitude.formatted())"
        }
        return nil
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        authReqCompletion?()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        completion?()
        if let location {
#if DEBUG
            print("Location updated: \(location.latitude), \(location.longitude)")
#endif
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completion?()
#if DEBUG
        print("Location failed: \(error)")
#endif
    }
}
