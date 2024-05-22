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
    @State private var alert = false
    @State private var alertMessage = ""
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
                    EmergencyContactPickerView(showPhoneNumberSelection: $showPhoneNumberSelection, phoneNumbers: $phoneNumbers, contact: $contact, alert: $alert, alertMessage: $alertMessage)
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
                            if isValidUSPhoneNumber(phoneNumber.stringValue) {
                                contact.phoneNumber = phoneNumber.stringValue
                            } else {
                                contact.isSelected = false
                                contact.displayName = ""
                                contact.phoneNumber = ""
                                alertMessage = "The selected contact does not have a valid phone number. Please select a contact with a US phone number."
                                alert = true
                            }
                            showPhoneNumberSelection = false
                        }
                })
            }
            .alert(isPresented: $alert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func isValidUSPhoneNumber(_ phoneNumber: String) -> Bool {
        let usPhoneNumberRegex = "^(?:\\+1|1)?[-.\\s]?\\(?\\d{3}\\)?[-.\\s]?\\d{3}[-.\\s]?\\d{4}$"
        return phoneNumber.range(of: usPhoneNumberRegex, options: .regularExpression) != nil
    }
}

struct EmergencyContactPickerView: UIViewControllerRepresentable {
    @Binding var showPhoneNumberSelection: Bool
    @Binding var phoneNumbers: [CNPhoneNumber]
    @Binding var contact: EmergencyContact
    @Binding var alert: Bool
    @Binding var alertMessage: String
    
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
            guard let displayName = CNContactFormatter.string(from: contact, style: .fullName), !displayName.isEmpty else {
                parent.alertMessage = "The selected contact does not have a display name. Please select a contact with a display name."
                parent.alert = true
                return
            }
            
            parent.contact.displayName = displayName
            parent.contact.isSelected = true
            
            let phoneNumbers = contact.phoneNumbers
            if phoneNumbers.count == 1 {
                parent.contact.phoneNumber = phoneNumbers.first?.value.stringValue ?? ""
            } else if phoneNumbers.count > 1 {
                parent.phoneNumbers = phoneNumbers.map { $0.value }
                parent.showPhoneNumberSelection = true
            } else {
                parent.contact.phoneNumber = ""
                parent.contact.isSelected = false
                parent.alertMessage = "The selected contact does not have a phone number. Please select a contact with a phone number."
                parent.alert = true
            }
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.contact.isSelected = false
            parent.contact.displayName = ""
            parent.contact.phoneNumber = ""
        }
    }
}
