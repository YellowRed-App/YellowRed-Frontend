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
    @Published var next: Bool = false
    @Published var alert: Bool = false
    private var locationManager: CLLocationManager?
    private var locationUpdateTimer: Timer?
    private let locationUpdateInterval: TimeInterval = 30.0
    private let db = Firestore.firestore()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
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
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: locationUpdateInterval, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(locationUpdateTimer!, forMode: .common)
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    @objc private func updateLocation() {
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if let userUID = Auth.auth().currentUser?.uid {
            sendLocationUpdate(userId: userUID, location: location) { result in
                switch result {
                case .success():
                    print("Location update sent successfully.")
                case .failure(let error):
                    print("Error sending location update: \(error)")
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
