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
    
    func createUser(fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String,
                    completion: @escaping (String?, Error?) -> Void) {
        let usersRef = db.collection("users")
        
        let userData: [String: Any] = [
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress,
            "affiliation": affiliation,
            "university": university
        ]
        
        var ref: DocumentReference? = nil
        ref = usersRef.addDocument(data: userData) { error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(ref?.documentID, nil)
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
    
    func addYellowRedMessagesToUser(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "yellowMessage": yellowMessage,
            "redMessage": redMessage
        ]) { error in
            completion(error)
        }
    }
    
}
