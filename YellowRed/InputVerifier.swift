//
//  InputVerifier.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI

class InputVerifier: ObservableObject {
    @Published var cooldown: Bool = false
    @Published var cooldownTime: Int = 0
    private var cooldownTimer: Timer? = nil

    func sendVerificationCodeViaSMS(to phoneNumber: String) -> String {
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via SMS to the phoneNumber
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code (SMS): \(randomCode)")
        
        return randomCode
    }
    
    func resendVerificationCodeViaSMS(to phoneNumber: String) -> String {
        guard !cooldown else {
            return ""
        }
        
        var verificationCode: String = ""
        verificationCode = sendVerificationCodeViaSMS(to: phoneNumber)
        
        startCooldown()
        
        return verificationCode
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
    
    private func startCooldown() {
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
}

