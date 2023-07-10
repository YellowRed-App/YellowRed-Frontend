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
        let phoneRegex = "^\\(\\d{3}\\) \\d{3}-\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    public static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    public static func validateAffiliation(affiliation: String, university: String) -> (isValid: Bool, isAffiliationValid: Bool, isUniversityValid: Bool) {
        var isValid = true
        var isAffiliationValid = true
        var isUniversityValid = true

        if affiliation == "Other" {
            isValid = !university.isEmpty
            isUniversityValid = !university.isEmpty
        } else {
            isValid = !affiliation.isEmpty
            isAffiliationValid = !affiliation.isEmpty
        }

        return (isValid, isAffiliationValid, isUniversityValid)
    }
    
    public static func validateEmergencyContacts(_ emergencyContacts: [EmergencyContact]) -> (emergencyContactsSelected: Set<Int>, emergencyContactsDuplicated: Set<Int>) {
        var emergencyContactsSelected = Set(emergencyContacts.indices.filter({ emergencyContacts[$0].isSelected }))
        var emergencyContactsDuplicated: Set<Int> = []
        
        if emergencyContactsSelected.count == emergencyContacts.count {
            let phoneNumbers = emergencyContacts.map({ $0.phoneNumber })
            let duplicatePhoneNumbers = phoneNumbers.duplicates()
            for (index, contact) in emergencyContacts.enumerated() {
                if duplicatePhoneNumbers.contains(contact.phoneNumber) {
                    emergencyContactsDuplicated.insert(index)
                }
            }
        }

        return (emergencyContactsSelected, emergencyContactsDuplicated)
    }
}

extension Array where Element: Hashable {
    func duplicates() -> Array {
        var counts = [Element: Int]()
        for element in self {
            counts[element, default: 0] += 1
        }
        return counts.filter({ $0.value > 1 }).map({ $0.key })
    }
}
