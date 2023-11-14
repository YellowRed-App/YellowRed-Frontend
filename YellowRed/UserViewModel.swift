//
//  UserViewModel.swift
//  YellowRed
//
//  Created by Krish Mehta on 11/4/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var userId: String?
    
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
    
}
