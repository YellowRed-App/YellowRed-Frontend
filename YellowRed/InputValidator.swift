//
//  InputValidator.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI

struct InputValidator {
    public static func validateFullName(_ fullName: String) -> Bool {
        let nameRegex = "^[a-zA-Z\\.\\'\\-]{2,50}(?: [a-zA-Z\\.\\'\\-]{2,50})+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: fullName)
    }
    
    public static func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[2-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    public static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func validateAffiliation(_ affiliation: String, _ university: String) -> Bool {
        if affiliation == "other" {
            return !university.isEmpty
        } else {
            return !affiliation.isEmpty
        }
    }
    
    static func validateEmergencyContacts(_ emergencyContacts: [EmergencyContact]) -> Bool {
        guard emergencyContacts.allSatisfy({ $0.isSelected }) else {
            return false
        }
        
        let phoneNumbers = emergencyContacts.map({ $0.phoneNumber })
        let uniquePhoneNumbers = Set(phoneNumbers)
        guard phoneNumbers.count == uniquePhoneNumbers.count else {
            return false
        }
        
        return true
    }
}
