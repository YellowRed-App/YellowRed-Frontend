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
    
    @State private var next = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .padding()
                
                Text("Emergency Contacts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Please get started by selecting three emergency contacts. You will be able to change this later.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        EmergencyContactPicker(contact: $emergencyContacts[index])
                    }
                }
                
                Spacer()
                
                Button(action: {
                    next = true
                }) {
                    Text("Next")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 100)
                        .background(.yellow)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                .background(
                    NavigationLink(
                        destination: MessagesView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

struct EmergencyContactPicker: View {
    @State private var isContactPickerPresented = false
    @Binding var contact: EmergencyContact
    
    var body: some View {
        HStack {
            Button(action: {
                isContactPickerPresented = true
            }) {
                Text(contact.isSelected ? contact.displayName : "Select Contact")
                    .foregroundColor(.blue)
                    .frame(maxWidth: 300, alignment: .leading)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isContactPickerPresented) {
                NavigationView {
                    ContactPickerView(contact: $contact)
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                isContactPickerPresented = false
                            }
                        )
                }
            }
        }
    }
}

struct ContactPickerView: UIViewControllerRepresentable {
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
            parent.contact.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            parent.contact.isSelected = true
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            // Handle cancel action if needed
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
