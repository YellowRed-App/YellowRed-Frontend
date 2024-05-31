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
    private var userViewModel = UserViewModel()
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
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
    }
    
    func fetchData(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        userViewModel.fetchUserData(userId: userUID) { [weak self] result in
            switch result {
            case .success():
                self?.userViewModel.fetchEmergencyContacts(userId: userUID) { result in
                    switch result {
                    case .success():
                        self?.userViewModel.fetchYellowRedMessages(userId: userUID) { result in
                            switch result {
                            case .success():
                                print("Successfully fetched all necessary data")
                                completion()
                            case .failure(let error):
                                print("Error fetching messages: \(error.localizedDescription)")
                                completion()
                            }
                        }
                    case .failure(let error):
                        print("Error fetching emergency contacts: \(error.localizedDescription)")
                        completion()
                    }
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
                completion()
            }
        }
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
    
    func activateButton(userId: String, button buttonState: ButtonState, completion: @escaping () -> Void) {
        fetchData {
            guard let userUID = Auth.auth().currentUser?.uid else {
                print("Data is not ready!")
                completion()
                return
            }
            
            let newSessionId = UUID().uuidString
            self.sessionId = newSessionId
            
            let firstName = self.userViewModel.fullName.components(separatedBy: " ").first ?? ""
            let button = buttonState == .yellow ? "Yellow" : "Red"
            let message = buttonState == .yellow ? self.userViewModel.yellowMessage : self.userViewModel.redMessage
            let liveLocationLink = "https://yellowred.app/live-location?user=\(userUID)&session=\(newSessionId)"
            
            self.sendEmergencyMessageIfNeeded(message: """
                                                              YellowRed: \(firstName) has activated the \(button) Button:
                                                              \(message)
                                                              \(liveLocationLink)
                                                              
                                                              YellowRed is a safety tool allowing users to communicate directly with emergency contacts, providing them with a user's preselected message and live location when the user activates a button. Please follow the instructions within the message and monitor \(firstName)'s location until \(firstName) has deactivated the \(button) Button.
                                                              """)
            
            UserDefaults.standard.set(button, forKey: "button")
            UserDefaults.standard.set(newSessionId, forKey: "currentSessionId")
            
            self.db.collection("users").document(userId).collection("sessions").document(newSessionId).setData([
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
                    
                    if buttonState == .yellow {
                        UserDefaults.standard.set(true, forKey: "YellowButtonActivated")
                    } else if buttonState == .red {
                        UserDefaults.standard.set(true, forKey: "RedButtonActivated")
                    }
                    
                    self?.notificationManager.scheduleNotification(button: buttonState.rawValue, sessionId: newSessionId)
                    
                    self?.deactivationTimer?.invalidate()
                    self?.deactivationTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: false) { [weak self] _ in
                        self?.deactivateButton()
                    }
                }
                completion()
            }
        }
    }
    
    func deactivateButton() {
        fetchData {
            guard let userUID = Auth.auth().currentUser?.uid else { return }
            
            let button = UserDefaults.standard.string(forKey: "button") ?? ""
            let currentSessionId = UserDefaults.standard.string(forKey: "currentSessionId") ?? ""
            
            let firstName = self.userViewModel.fullName.components(separatedBy: " ").first ?? ""
            
            self.sendEmergencyMessageIfNeeded(message: """
                                             \(firstName) has deactivated the \(button) Button, indicating they have arrived safely at their destination. No further action is necessary. For more information on YellowRed, visit the YellowRed website at https://yellowred.app.
                                             """)
            
            self.notificationManager.cancelNotification(sessionId: currentSessionId)
            
            if button == "Yellow" {
                self.markDeleteSessionForYellowButton(userUID: userUID, sessionId: currentSessionId)
                UserDefaults.standard.set(false, forKey: "YellowButtonActivated")
            } else if button == "Red" {
                self.markDeleteSessionForRedButton(userUID: userUID, sessionId: currentSessionId)
                UserDefaults.standard.set(false, forKey: "RedButtonActivated")
            }
            
            UserDefaults.standard.removeObject(forKey: "button")
            UserDefaults.standard.removeObject(forKey: "currentSessionId")
            
            self.deactivationTimer?.invalidate()
            self.deactivationTimer = nil
            
            self.sessionId = nil
            self.activeButton = .none
            self.stopUpdatingLocation()
        }
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
    
    private func beginBackgroundUpdateTask() {
        bgTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundUpdateTask()
        }
    }
    
    private func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.bgTask)
        self.bgTask = .invalid
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
    
    func sendEmergencyMessageIfNeeded(message: String) {
        let emergencyContactNumbers = userViewModel.emergencyContacts.map { $0.phoneNumber }
        sendEmergencyMessage(contacts: emergencyContactNumbers, message: message)
    }
    
    private func sendEmergencyMessage(contacts: [String], message: String) {
        guard let url = URL(string: "https://us-central1-yellowred-app.cloudfunctions.net/sendEmergencySMS") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = ["contacts": contacts, "message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        print("Sending payload: \(payload)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending SMS: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status code: \(httpResponse.statusCode)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data: \(dataString)")
            }
        }.resume()
    }
}
