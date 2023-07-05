//
//  BackButton.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Back")
                    .foregroundColor(.white)
            }
        }
    }
}

struct RadioButton: View {
    let id: String
    let label: String
    @Binding var isSelected: String
    @Binding var isAffiliationValid: Bool
    
    var body: some View {
        Button(action: {
            isSelected = id
            isAffiliationValid = true
        }) {
            HStack(alignment: .top) {
                Image(systemName: isSelected == id ? "largecircle.fill.circle" : "circle")
                Text(label)
            }
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .padding(12.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
        }
    }
}
