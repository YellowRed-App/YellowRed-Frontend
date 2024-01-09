//
//  InputValidator.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI

final class InputValidator: ObservableObject {
    @Published var isFullNameValid: Bool = true
    @Published var isPhoneNumberValid: Bool = true
    @Published var isEmailAddressValid: Bool = true
    @Published var isAffiliated: Bool = true
    @Published var isAffiliationValid: Bool = true
    @Published var isUniversityValid: Bool = true
    @Published var emergencyContactsSelected: Set<Int> = []
    @Published var emergencyContactsDuplicated: Set<Int> = []
    @Published var areEmergencyContactsValid: Bool = false
    
    func validateFullName(_ fullName: String) {
        let nameRegex = "^[a-zA-Z\\.\\'\\-]{2,50}(?: [a-zA-Z\\.\\'\\-]{2,50})+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        isFullNameValid = namePredicate.evaluate(with: fullName)
    }
    
    func validatePhoneNumber(_ phoneNumber: String) {
        let phoneRegex = "^\\(\\d{3}\\) \\d{3}-\\d{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isPhoneNumberValid = phonePredicate.evaluate(with: phoneNumber)
    }
    
    func validateEmailAddress(_ emailAddress: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailAddressValid = emailPredicate.evaluate(with: emailAddress)
    }
    
    func validateAffiliation(_ affiliation: String, _ university: String) {
        if affiliation == "Other" {
            isAffiliated = !university.isEmpty
            isUniversityValid = !university.isEmpty
        } else {
            isAffiliated = !affiliation.isEmpty
            isAffiliationValid = !affiliation.isEmpty
        }
    }
    
    func validateEmergencyContacts(_ emergencyContacts: [EmergencyContact]) {
        emergencyContactsSelected = Set(emergencyContacts.indices.filter({ emergencyContacts[$0].isSelected }))
        emergencyContactsDuplicated = []
        
        if emergencyContactsSelected.count == emergencyContacts.count {
            let phoneNumbers = emergencyContacts.map({ $0.phoneNumber })
            let duplicatePhoneNumbers = phoneNumbers.duplicates()
            
            for (index, contact) in emergencyContacts.enumerated() {
                if duplicatePhoneNumbers.contains(contact.phoneNumber) {
                    emergencyContactsDuplicated.insert(index)
                }
            }
        }
        if emergencyContactsSelected.count == emergencyContacts.count && emergencyContactsDuplicated.isEmpty {
            areEmergencyContactsValid = true
        }
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
