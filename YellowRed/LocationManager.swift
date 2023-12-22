//
//  LocationManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 7/7/23.
//

import CoreLocation
import FirebaseAuth
import FirebaseFirestore

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    enum ButtonState {
        case yellow
        case red
        case none
    }
    
    @Published var next: Bool = false
    @Published var alert: Bool = false
    private var locationManager: CLLocationManager?
    private var locationUpdateTime: Date?
    private var locationUpdateInterval: TimeInterval = 60.0
    private var activeButton: ButtonState = .none
    private let db = Firestore.firestore()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = kCLDistanceFilterNone
    }
    
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.next = true
            }
        case .notDetermined:
            DispatchQueue.main.async {
                self.locationManager?.requestAlwaysAuthorization()
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.alert = true
            }
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
    
    func activateYellowButton() {
        activeButton = .yellow
        locationUpdateInterval = 60.0
        startUpdatingLocation()
    }
    
    func activateRedButton() {
        activeButton = .red
        locationUpdateInterval = 30.0
        startUpdatingLocation()
    }
    
    func deactivateButton() {
        activeButton = .none
        stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard activeButton != .none else { return }
        guard let location = locations.last else { return }

        // throttle the update frequency
        let currentTime = Date().timeIntervalSince1970
        if currentTime - (locationUpdateTime?.timeIntervalSince1970 ?? 0) >= locationUpdateInterval {
            locationUpdateTime = Date()
            
            if let userUID = Auth.auth().currentUser?.uid {
                sendLocationUpdate(userId: userUID, location: location) { result in
                    switch result {
                    case .success():
                        print("\(Date()): Location update sent successfully.")
                    case .failure(let error):
                        print("Error sending location update: \(error)")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
    
    private func sendLocationUpdate(userId: String, location: CLLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let locationData: [String: Any] = [
            "timestamp": Timestamp(date: Date()), // FieldValue.serverTimestamp() for server-side timestamp
            "geopoint": geoPoint
        ]
        
        db.collection("users").document(userId).collection("locationUpdates").addDocument(data: locationData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
