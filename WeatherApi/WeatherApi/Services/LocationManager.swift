//
//  LocationManager.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/15/24.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var location: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    private var completion: (()->Void)?
    private var authReqCompletion: (()->Void)?

    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation(completion: @escaping ()->Void) {
        self.completion = completion
        locationManager.requestLocation()
    }
    
    public func requestAuthorization(always: Bool = false, completion: @escaping ()->Void) {
        self.authReqCompletion = completion
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
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

