//
//  WelcomeView.swift
//  YellowRed
//
//  Created by Krish Mehta on 17/6/23.
//

import SwiftUI
import ContactsUI

struct EmergencyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var emergencyContacts: [EmergencyContact] = Array(repeating: EmergencyContact(), count: 3)
    
    @State private var valid: Bool = true
    
    @State private var next: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Emergency Contacts")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Please get started by selecting three emergency contacts. You will be able to change this later.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        EmergencyContactPicker(contact: $emergencyContacts[index])
                    }
                }
                .padding(.horizontal, 20)
                
                if !valid {
                    Text("Please select three unique emergency contacts!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    valid = validate(emergencyContacts: emergencyContacts)
                    next = valid
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 20)
                .background(
                    NavigationLink(
                        destination: YellowMessageView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func validate(emergencyContacts: [EmergencyContact]) -> Bool {
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
            }
            .padding(12.5)
            .background(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isContactPickerPresented) {
                NavigationView {
                    ContactPickerView(showPhoneNumberSelection: $showPhoneNumberSelection, phoneNumbers: $phoneNumbers, contact: $contact)
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

struct ContactPickerView: UIViewControllerRepresentable {
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
        let parent: ContactPickerView
        
        init(_ parent: ContactPickerView) {
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

struct EmergencyContact {
    var isSelected = false
    var displayName = ""
    var phoneNumber = ""
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView()
    }
}
