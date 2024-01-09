//
//  UserAuth.swift
//  YellowRed
//
//  Created by Krish Mehta on 12/18/23.
//

import Foundation
import FirebaseAuth

class UserAuth: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    
    init() {
        updateAuthenticationStatus()
    }
    
    func updateAuthenticationStatus() {
        if let user = Auth.auth().currentUser {
            print("User is logged in: \(user.uid)")
            isUserAuthenticated = true
        } else {
            print("No user is logged in.")
            isUserAuthenticated = false
        }
    }
}
