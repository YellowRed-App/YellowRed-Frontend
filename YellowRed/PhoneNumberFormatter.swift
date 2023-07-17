//
//  PhoneNumberFormatter.swift
//  YellowRed
//
//  Created by Krish Mehta on 7/7/23.
//

import Foundation

class PhoneNumberFormatter {
    static func format(phone: String) -> String? {
        let numbers = phone.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let pureNumber = numbers.joined()

        var finalText = ""
        var index = 0

        for char in pureNumber {
            if index == 3 {
                finalText += ") "
            }
            if index == 6 {
                finalText += "-"
            }
            finalText += String(char)
            index += 1
        }
        
        if finalText.count > 0 && finalText.count < 14 && !finalText.hasPrefix("(") {
            finalText.insert("(", at: finalText.startIndex)
        }
        
        return finalText
    }
}

