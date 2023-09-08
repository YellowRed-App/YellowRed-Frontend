//
//  InputVerifier.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI
import FirebaseAuth

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
    
    func sendVerificationCode(to phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.verificationID = verificationID ?? ""
            self.isVerificationEnabled = true
        }
    }
    
    func resendVerificationCode(to phoneNumber: String) {
        guard !cooldown else {
            return
        }
        
        sendVerificationCode(to: "+1\(phoneNumber)")
        startCooldown()
    }
    
    func verifyVerificationCode(_ verificationCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            self.showMessagePrompt("Verification ID not found.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.isVerificationValid = false
            } else {
                self.isVerificationValid = true
                self.next = true
                self.stopCooldown()
            }
        }
    }
    
    func sendVerificationCodeViaEmail(to emailAddress: String) -> String {
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via email to the email address
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code (Email): \(randomCode)")
        
        return randomCode
    }
    
    func resendVerificationCodeViaEmail(to emailAddress: String) -> String {
        guard !cooldown else {
            return ""
        }
        
        var verificationCode: String = ""
        verificationCode = sendVerificationCodeViaEmail(to: emailAddress)
        
        startCooldown()
        
        return verificationCode
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

