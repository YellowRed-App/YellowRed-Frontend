//
//  InputVerifier.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

final class InputVerifier: ObservableObject {
    @Published var cooldown: Bool = false
    @Published var cooldownTime: Int = 0
    private var cooldownTimer: Timer? = nil
    
    @Published var alert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var verificationID: String = ""
    @Published var verificationCode: String = ""
    
    @Published var isVerificationEnabled: Bool = false
    @Published var isVerificationValid: Bool = true
    
    @Published var next: Bool = false
    
    private let db = Firestore.firestore()
    
    func sendVerificationCode(to phoneNumber: String) {
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        print(formattedPhoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                // Print detailed error information
                print("Error verifying phone number: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("Error domain: \(nsError.domain)")
                    print("Error code: \(nsError.code)")
                    print("Error userInfo: \(nsError.userInfo)")
                }
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            self.verificationID = verificationID ?? ""
            self.isVerificationEnabled = true
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
            // Remove non-digit characters
            let digitsOnly = phoneNumber.filter { $0.isNumber }
            
            // Ensure the phone number starts with '+'
            if !digitsOnly.hasPrefix("+") {
                return "+" + digitsOnly
            }
            
            return digitsOnly
        }
    
    func resendVerificationCode(to phoneNumber: String) {
        guard !cooldown else {
            return
        }
        
        sendVerificationCode(to: "+1\(phoneNumber)")
        startCooldown()
    }
    
    func verifyVerificationCode(_ verificationCode: String) {
//        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
//            self.showMessagePrompt("Verification ID not found.")
//            return
//        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if error != nil {
                self.isVerificationValid = false
            } else {
                self.isVerificationValid = true
                self.next = true
                self.stopCooldown()
            }
        }
    }
    
    func sendVerificationCodeViaEmail(to emailAddress: String) {
        let randomCode = String(format: "%06d", Int.random(in: 0..<1000000))
        UserDefaults.standard.set(randomCode, forKey: "emailVerificationID")
        let docRef = db.collection("mail").document()
        docRef.setData([
            "to": [emailAddress],
            "message": [
                "subject": "Your YellowRed Verification Code",
                "text": "Your verification code is \(randomCode)"
            ]
        ]) { error in
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            self.isVerificationEnabled = true
        }
    }
    
    func resendVerificationCodeViaEmail(to emailAddress: String) {
        guard !cooldown else {
            return
        }
        
        sendVerificationCodeViaEmail(to: emailAddress)
        startCooldown()
    }
    
    func verifyVerificationCodeViaEmail(_ verificationCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "emailVerificationID") else {
            self.showMessagePrompt("Verification ID not found.")
            return
        }
        
        if verificationCode == verificationID {
            self.isVerificationValid = true
            self.next = true
            self.stopCooldown()
        } else {
            self.isVerificationValid = false
        }
    }
    
    func startCooldown() {
        cooldown = true
        cooldownTime = 60
        
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            if self?.cooldownTime ?? 0 > 0 {
                self?.cooldownTime -= 1
            } else {
                timer.invalidate()
                self?.cooldown = false
            }
        }
    }
    
    func stopCooldown() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        cooldown = false
    }
    
    func showMessagePrompt(_ message: String) {
        alertMessage = message
        alert = true
    }
}

