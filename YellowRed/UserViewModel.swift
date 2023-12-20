//
//  UserViewModel.swift
//  YellowRed
//
//  Created by Krish Mehta on 11/4/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var userId: String?
    
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var emailAddress: String = ""
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var yellowMessage: String = ""
    @Published var redMessage: String = ""
    
    private let firestoreManager = FirestoreManager()
    
    func createUser(userUID: String, fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String, completion: @escaping (Bool) -> Void) {
        firestoreManager.createUser(userUID: userUID, fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.userId = userUID
                completion(true)
            }
        }
    }
    
    func updateUser(userId: String, phoneNumber: String, emailAddress: String, completion: @escaping (Bool) -> Void) {
        firestoreManager.updateUser(userId: userId, phoneNumber: phoneNumber, emailAddress: emailAddress) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.phoneNumber = phoneNumber
                    self.emailAddress = emailAddress
                }
                completion(true)
            }
        }
    }
    
    func addEmergencyContacts(emergencyContacts: [EmergencyContact], completion: @escaping (Bool) -> Void) {
        guard let userId = userId else {
            completion(false)
            return
        }
        
        firestoreManager.addEmergencyContactsToUser(userId: userId, emergencyContacts: emergencyContacts) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateEmergencyContacts(userId: String, emergencyContacts: [EmergencyContact], completion: @escaping (Bool) -> Void) {
        firestoreManager.updateEmergencyContactsForUser(userId: userId, emergencyContacts: emergencyContacts) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.emergencyContacts = emergencyContacts
                }
                completion(true)
            }
        }
    }
    
    func addYellowRedMessages(yellowMessage: String, redMessage: String, completion: @escaping (Bool) -> Void) {
        guard let userId = userId else {
            completion(false)
            return
        }
        
        firestoreManager.addYellowRedMessagesToUser(userId: userId, yellowMessage: yellowMessage, redMessage: redMessage) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateYellowRedMessages(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Bool) -> Void) {
        firestoreManager.updateYellowRedMessagesForUser(userId: userId, yellowMessage: yellowMessage, redMessage: redMessage) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.yellowMessage = yellowMessage
                    self.redMessage = redMessage
                }
                completion(true)
            }
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping () -> Void) {
        firestoreManager.fetchUserData(userId: userId) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.fullName = data["fullName"] as? String ?? ""
                    self.phoneNumber = data["phoneNumber"] as? String ?? ""
                    self.emailAddress = data["emailAddress"] as? String ?? ""
                    completion()
                }
            case .failure(let error):
                print("Error fetching user data: \(error)")
                completion()
            }
        }
    }
    
    func fetchEmergencyContacts(userId: String, completion: @escaping () -> Void) {
        firestoreManager.fetchEmergencyContactsForUser(userId: userId) { result in
            switch result {
            case .success(let contacts):
                DispatchQueue.main.async {
                    self.emergencyContacts = contacts
                    completion()
                }
            case .failure(let error):
                print("Error fetching emergency contacts: \(error)")
                completion()
            }
        }
    }
    
    func fetchYellowRedMessages(userId: String, completion: @escaping () -> Void) {
        firestoreManager.fetchYellowRedMessagesForUser(userId: userId) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.yellowMessage = messages.yellowMessage
                    self.redMessage = messages.redMessage
                    completion()
                }
            case .failure(let error):
                print("Error fetching messages: \(error)")
                completion()
            }
        }
    }
    
}
