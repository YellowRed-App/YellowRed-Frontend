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
    private var notificationManager = NotificationManager()
    private var locationManager: CLLocationManager?
    private var locationUpdateTime: Date?
    private var locationUpdateInterval: TimeInterval = 60.0
    private var activeButton: ButtonState = .none
    private var deactivationTimer: Timer?
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
        let status = locationManager?.authorizationStatus ?? .notDetermined
        
        switch status {
        case .authorizedAlways:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.next = true
            }
        case .authorizedWhenInUse, .notDetermined:
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
        switch status {
        case .authorizedAlways:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.next = true
            }
        case .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.alert = true
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.alert = true
            }
        default:
            break
        }
    }
    
    func getCurrentSessionId() -> String? {
        return sessionId
    }
    
    func activateButton(button buttonState: ButtonState, completion: @escaping (String?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil);
            return
        }
        
        let newSessionId = UUID().uuidString
        sessionId = newSessionId
        
        db.collection("users").document(userUID).collection("sessions").document(newSessionId).setData([
            "active": true,
            "button": buttonState.rawValue,
            "startTime": Timestamp(date: Date())
        ]) { [weak self] error in
            if let error = error {
                print("Error starting session: \(error)")
                completion(nil)
            } else {
                print("Session started with ID: \(newSessionId)")
                self?.activeButton = buttonState
                self?.locationUpdateInterval = buttonState == .yellow ? 60.0 : 30.0
                self?.startUpdatingLocation()
                completion(newSessionId)
                
                self?.notificationManager.scheduleNotification(button: buttonState.rawValue, sessionId: newSessionId)
                
                self?.deactivationTimer?.invalidate()
                self?.deactivationTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: false) { [weak self] _ in
                    self?.deactivateButton()
                }
            }
        }
    }
    
    func deactivateButton() {
        deactivationTimer?.invalidate()
        deactivationTimer = nil
        
        guard let userUID = Auth.auth().currentUser?.uid, let currentSessionId = sessionId else { return }
        
        if activeButton == .yellow {
            markDeleteSessionForYellowButton(userUID: userUID, sessionId: currentSessionId)
        } else if activeButton == .red {
            markDeleteSessionForRedButton(userUID: userUID, sessionId: currentSessionId)
        }
        
        sessionId = nil
        activeButton = .none
        stopUpdatingLocation()
    }
    
    private func markDeleteSessionForYellowButton(userUID: String, sessionId: String) {
        let sessionRef = db.collection("users").document(userUID).collection("sessions").document(sessionId)
        
        sessionRef.updateData([
            "active": false,
            "endTime": Timestamp(date: Date())
        ]) { [weak self] error in
            if let error = error {
                print("Error updating session document: \(error)")
            } else {
                print("Session document updated successfully.")
                
                sessionRef.collection("locationUpdates").getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        print("Error fetching sub-collection documents: \(error?.localizedDescription ?? "Unknown Error")")
                        return
                    }
                    
                    let batch = self?.db.batch()
                    
                    snapshot.documents.forEach { document in
                        batch?.deleteDocument(document.reference)
                    }
                    
                    batch?.commit { batchError in
                        if let batchError = batchError {
                            print("Error deleting location updates: \(batchError.localizedDescription)")
                        } else {
                            print("Location updates deleted successfully.")
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
                sendLocationUpdate(userId: userUID, sessionId: currentSessionId, location: location) { result in
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
    
    private func sendLocationUpdate(userId: String, sessionId: String, location: CLLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let locationData: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "geopoint": geoPoint,
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
