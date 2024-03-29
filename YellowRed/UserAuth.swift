//
//  UserAuth.swift
//  YellowRed
//
//  Created by Krish Mehta on 12/18/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserAuth: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var isUserDataComplete: Bool = false
    @Published var isLoading: Bool = true
    
    private var firestoreManager = FirestoreManager()
    
    init() {
        updateAuthenticationStatus()
    }
    
    func updateAuthenticationStatus() {
        isLoading = true
        if let user = Auth.auth().currentUser {
            print("User is logged in: \(user.uid)")
            isUserAuthenticated = true
            validateUserDataComplete(userID: user.uid)
        } else {
            print("No user is logged in.")
            isUserAuthenticated = false
            isUserDataComplete = false
            isLoading = false
        }
    }
    
    func validateUserDataComplete(userID: String) {
        firestoreManager.fetchUserData(userId: userID) { [weak self] result in
            switch result {
            case .success(let data):
                let emailAddress = data["emailAddress"] as? String ?? ""
                let hasEmailAddress = !emailAddress.isEmpty
                self?.firestoreManager.fetchEmergencyContacts(userId: userID) { result in
                    switch result {
                    case .success(let contacts):
                        let hasContacts = !contacts.isEmpty
                        self?.firestoreManager.fetchYellowRedMessages(userId: userID) { result in
                            switch result {
                            case .success(let messages):
                                DispatchQueue.main.async {
                                    self?.isUserDataComplete = hasEmailAddress && hasContacts
                                    self?.isLoading = false
                                }
                            case .failure:
                                DispatchQueue.main.async {
                                    self?.isUserDataComplete = false
                                    self?.isLoading = false
                                }
                            }
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self?.isUserDataComplete = false
                            self?.isLoading = false
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.isUserDataComplete = false
                    self?.isLoading = false
                }
            }
        }
    }
}
