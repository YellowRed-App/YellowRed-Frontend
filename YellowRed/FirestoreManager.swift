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

}
