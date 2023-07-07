//
//  EmergencyContactManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 4/7/23.
//

import SwiftUI
import ContactsUI

struct EmergencyContact: Hashable {
    var isSelected = false
    var displayName = ""
    var phoneNumber = ""

    init(isSelected: Bool = false, displayName: String = "", phoneNumber: String = "") {
        self.isSelected = isSelected
        self.displayName = displayName
        self.phoneNumber = phoneNumber
    }
}

struct EmergencyContactPicker: View {
    @State private var isContactPickerPresented = false
    @State private var showPhoneNumberSelection = false
    @State private var phoneNumbers: [CNPhoneNumber] = []
    @Binding var contact: EmergencyContact
    
    var body: some View {
        HStack {
            Button(action: {
                isContactPickerPresented = true
            }) {
                Text(contact.isSelected ? "\(contact.displayName) (\(contact.phoneNumber))" : "Select Contact")
                    .foregroundColor(.blue)
                    .frame(maxWidth: 300, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(12.5)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
            .sheet(isPresented: $isContactPickerPresented) {
                NavigationView {
                    EmergencyContactPickerView(showPhoneNumberSelection: $showPhoneNumberSelection, phoneNumbers: $phoneNumbers, contact: $contact)
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                isContactPickerPresented = false
                            }
                        )
                }
            }
            .actionSheet(isPresented: $showPhoneNumberSelection) {
                ActionSheet(title: Text("Select a Phone Number"), buttons: phoneNumbers.map { phoneNumber in
                        .default(Text(phoneNumber.stringValue)) {
                            contact.phoneNumber = phoneNumber.stringValue
                            showPhoneNumberSelection = false
                        }
                })
            }
        }
    }
}

struct EmergencyContactPickerView: UIViewControllerRepresentable {
    @Binding var showPhoneNumberSelection: Bool
    @Binding var phoneNumbers: [CNPhoneNumber]
    @Binding var contact: EmergencyContact
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = context.coordinator
        return contactPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: EmergencyContactPickerView
        
        init(_ parent: EmergencyContactPickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.contact.displayName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            parent.contact.isSelected = true
            
            let phoneNumbers = contact.phoneNumbers
            if phoneNumbers.count == 1 {
                parent.contact.phoneNumber = phoneNumbers.first?.value.stringValue ?? ""
            } else if phoneNumbers.count > 1 {
                parent.phoneNumbers = phoneNumbers.map { $0.value }
                parent.showPhoneNumberSelection = true
            }
        }
    }
}
