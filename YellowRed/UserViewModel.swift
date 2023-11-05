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
    
    func createUser(fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String,
                    completion: @escaping (Bool) -> Void) {
        firestoreManager.createUser(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress,
                                    affiliation: affiliation, university: university) { userId, error in
            if let userId = userId {
                self.userId = userId
                completion(true)
            } else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(false)
            }
        }
    }

}
