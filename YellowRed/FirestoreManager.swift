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
    
    func createUser(userUID: String, fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users")
        let userData: [String: Any] = [
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress,
            "affiliation": affiliation,
            "university": university
        ]
        
        userRef.document(userUID).setData(userData) { error in
            completion(error)
        }
    }
    
    func updateUser(userId: String, phoneNumber: String, emailAddress: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress
        ]) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func addEmergencyContactsToUser(userId: String, emergencyContacts: [EmergencyContact], completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        
        let batch = db.batch()
        
        for contact in emergencyContacts {
            let contactRef = userRef.collection("emergencyContacts").document()
            let contactData: [String: Any] = [
                "displayName": contact.displayName,
                "phoneNumber": contact.phoneNumber
            ]
            batch.setData(contactData, forDocument: contactRef)
        }
        
        batch.commit { error in
            completion(error)
        }
    }
    
    func updateEmergencyContactsForUser(userId: String, emergencyContacts: [EmergencyContact], completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let contactsRef = userRef.collection("emergencyContacts")
        
        contactsRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                // delete existing contacts
                snapshot?.documents.forEach { document in
                    transaction.deleteDocument(document.reference)
                }

                // add new contacts
                emergencyContacts.forEach { contact in
                    let newContactRef = contactsRef.document()
                    transaction.setData([
                        "displayName": contact.displayName,
                        "phoneNumber": contact.phoneNumber
                    ], forDocument: newContactRef)
                }
                
                return nil
            }) { (_, error) in
                completion(error)
            }
        }
    }
    
    func addYellowRedMessagesToUser(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "yellowMessage": yellowMessage,
            "redMessage": redMessage
        ]) { error in
            completion(error)
        }
    }
    
    func updateYellowRedMessagesForUser(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "yellowMessage": yellowMessage,
            "redMessage": redMessage
        ]) { error in
            completion(error)
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    func fetchEmergencyContactsForUser(userId: String, completion: @escaping (Result<[EmergencyContact], Error>) -> Void) {
        let contactsRef = db.collection("users").document(userId).collection("emergencyContacts")
        contactsRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var contacts: [EmergencyContact] = []
                querySnapshot?.documents.forEach { document in
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
    
    func fetchYellowRedMessagesForUser(userId: String, completion: @escaping (Result<(yellowMessage: String, redMessage: String), Error>) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data() ?? [:]
                let yellowMessage = data["yellowMessage"] as? String ?? ""
                let redMessage = data["redMessage"] as? String ?? ""
                completion(.success((yellowMessage: yellowMessage, redMessage: redMessage)))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
}
