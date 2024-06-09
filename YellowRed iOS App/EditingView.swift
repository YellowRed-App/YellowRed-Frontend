//
//  EditingView.swift
//  YellowRed
//
//  Created by Krish Mehta on 7/7/23.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func endEditingOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
