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
    enum ButtonState: String {
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
    private var sessionId: String?
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
    
    func activateButton(button buttonState: ButtonState) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let newSessionId = UUID().uuidString
        sessionId = newSessionId
        
        db.collection("users").document(userUID).collection("sessions").document(newSessionId).setData([
            "active": true,
            "button": buttonState.rawValue,
            "startTime": Timestamp(date: Date())
        ]) { [weak self] error in
            if let error = error {
                print("Error starting session: \(error)")
            } else {
                print("Session started with ID: \(newSessionId)")
                self?.activeButton = buttonState
                self?.locationUpdateInterval = buttonState == .yellow ? 60.0 : 30.0
                self?.startUpdatingLocation()
            }
        }
    }
    
    func deactivateButton() {
        guard let userUID = Auth.auth().currentUser?.uid, let currentSessionId = sessionId else { return }
        
        if activeButton == .yellow {
            deleteSessionForYellowButton(userUID: userUID, sessionId: currentSessionId)
        } else if activeButton == .red {
            markDeleteSessionForRedButton(userUID: userUID, sessionId: currentSessionId)
        }
        
        sessionId = nil
        activeButton = .none
        stopUpdatingLocation()
    }
    
    private func deleteSessionForYellowButton(userUID: String, sessionId: String) {
        let sessionRef = db.collection("users").document(userUID).collection("sessions").document(sessionId)
        
        sessionRef.collection("locationUpdates").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching sub-collection documents: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            let batch = self.db.batch()
            
            snapshot.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { [weak self] batchError in
                if let batchError = batchError {
                    print("Error deleting location updates: \(batchError.localizedDescription)")
                } else {
                    self?.db.collection("users").document(userUID).collection("sessions").document(sessionId).delete { sessionError in
                        if let sessionError = sessionError {
                            print("Error deleting session document: \(sessionError.localizedDescription)")
                        } else {
                            print("Session document and all related location updates deleted successfully.")
                        }
                    }
                }
            }
        }
    }
    
    private func markDeleteSessionForRedButton(userUID: String, sessionId: String) {
        db.collection("users").document(userUID).collection("sessions").document(sessionId).updateData([
            "active": false,
            "endTime": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error marking delete session for red button: \(error)")
            } else {
                print("Session for red button marked for deletion successfully.")
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, let currentSessionId = sessionId else { return }
        
        let buttonState = activeButton.rawValue
        
        // throttle the update frequency
        if Date().timeIntervalSince(locationUpdateTime ?? Date.distantPast) >= locationUpdateInterval {
            locationUpdateTime = Date()
            if let userUID = Auth.auth().currentUser?.uid {
                sendLocationUpdate(userId: userUID, sessionId: currentSessionId, location: location, buttonState: buttonState) { result in
                    switch result {
                    case .success():
                        print("\(Date()): Location update for \(buttonState) button sent successfully.")
                    case .failure(let error):
                        print("Error sending location update: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
    
    private func sendLocationUpdate(userId: String, sessionId: String, location: CLLocation, buttonState: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let locationData: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "geopoint": geoPoint,
            "button": buttonState
        ]
        
        db.collection("users").document(userId).collection("sessions").document(sessionId).collection("locationUpdates").addDocument(data: locationData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
