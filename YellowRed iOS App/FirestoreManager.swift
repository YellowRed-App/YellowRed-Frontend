//
//  FirestoreManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 11/4/23.
//

import Foundation
import FirebaseFirestore

class FirestoreManager {
    
    private let db = Firestore.firestore()
    
    func createUser(userId: String, fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData = [
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress,
            "affiliation": affiliation,
            "university": university
        ]
        db.collection("users").document(userId).setData(userData) { error in
            self.handleCompletion(error, completion: completion)
        }
    }
    
    func updateUser(userId: String, phoneNumber: String, emailAddress: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let updateData = [
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress
        ]
        db.collection("users").document(userId).updateData(updateData) { error in
            self.handleCompletion(error, completion: completion)
        }
    }
    
    func updateEmergencyContacts(userId: String, emergencyContacts: [EmergencyContact], completion: @escaping (Result<Void, Error>) -> Void) {
        let contactsRef = db.collection("users").document(userId).collection("emergencyContacts")
        contactsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let batch = self.db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            emergencyContacts.forEach { contact in
                let newContactRef = contactsRef.document()
                let contactData = [
                    "displayName": contact.displayName,
                    "phoneNumber": contact.phoneNumber
                ]
                batch.setData(contactData, forDocument: newContactRef)
            }

            batch.commit { error in
                self.handleCompletion(error, completion: completion)
            }
        }
    }
    
    func updateYellowRedMessages(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let updateData = [
            "yellowMessage": yellowMessage,
            "redMessage": redMessage
        ]
        db.collection("users").document(userId).updateData(updateData) { error in
            self.handleCompletion(error, completion: completion)
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                self.handleNonExistentDocument(completion: completion)
            }
        }
    }
    
    func fetchYellowRedMessages(userId: String, completion: @escaping (Result<(yellowMessage: String, redMessage: String), Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data() ?? [:]
                let yellowMessage = data["yellowMessage"] as? String ?? ""
                let redMessage = data["redMessage"] as? String ?? ""
                completion(.success((yellowMessage: yellowMessage, redMessage: redMessage)))
            } else {
                self.handleNonExistentDocument(completion: completion)
            }
        }
    }
    
    func fetchEmergencyContacts(userId: String, completion: @escaping (Result<[EmergencyContact], Error>) -> Void) {
        db.collection("users").document(userId).collection("emergencyContacts").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var contacts: [EmergencyContact] = []
                snapshot?.documents.forEach { document in
                    let data = document.data()
                    let contact = EmergencyContact(
                        isSelected: false,
                        displayName: data["displayName"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? String ?? ""
                    )
                    contacts.append(contact)
                }
                completion(.success(contacts))
            }
        }
    }
    
    private func handleCompletion<T>(_ error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            NSLog("Error: \(error.localizedDescription)")
            completion(.failure(error))
        } else {
            completion(.success(() as! T))
        }
    }
    
    private func handleNonExistentDocument<T>(completion: (Result<T, Error>) -> Void) {
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
        completion(.failure(error))
    }
    
}
