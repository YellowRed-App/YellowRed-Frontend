//
//  LocationManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 7/7/23.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var next: Bool = false
    @Published var alert: Bool = false
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.next = true
            }
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            alert = true
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.next = true
            }
        }
    }
}
