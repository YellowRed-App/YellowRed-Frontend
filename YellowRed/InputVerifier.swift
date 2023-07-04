//
//  InputVerifier.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI

struct InputVerifier {
    static func sendVerificationCodeViaSMS(to phoneNumber: String) -> String {
        // Generate a random six-digit code
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via SMS to the phoneNumber
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code (SMS): \(randomCode)")
        
        return randomCode
    }
    
    static func sendVerificationCodeViaEmail(to email: String) -> String {
        // Generate a random six-digit code
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via email to the email address
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code (Email): \(randomCode)")
        
        return randomCode
    }
}
