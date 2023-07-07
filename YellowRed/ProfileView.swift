//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 7/1/23.
//  Revamped by Krish Mehta on 4/7/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = "John Smith"
    @State private var phoneNumber: String = "(123) 456-7890"
    @State private var emailAddress: String = "abc5xy@virginia.edu"
    @State private var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(isSelected: true, displayName: "John Doe", phoneNumber: "+1 (234) 567-8901"),
        EmergencyContact(isSelected: true, displayName: "Jane Doe", phoneNumber: "+1 (234) 567-8902"),
        EmergencyContact(isSelected: true, displayName: "Baby Doe", phoneNumber: "+1 (234) 567-8903")
    ]
    
    @State private var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    @State private var redMessage: String = "I'm feeling a bit unsafe, can you check on me"
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 96, height: 96)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text(fullName)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(25)
                        .edgesIgnoringSafeArea(.all)
                    )
                    
                    VStack {
                        SectionView(title: "Personal Info", content:  {
                            InfoView(title: "Phone Number", value: phoneNumber)
                            InfoView(title: "Email Address", value: emailAddress)
                        }, destinationView: AnyView(EditPersonalView(fullName: $fullName, phoneNumber: $phoneNumber, emailAddress: $emailAddress)))
                        
                        SectionView(title: "Emergency Contacts", content:  {
                            ForEach(emergencyContacts.indices, id: \.self) { index in
                                InfoView(title: "Contact \(index + 1)", value: "\(emergencyContacts[index].displayName) (\(emergencyContacts[index].phoneNumber))")
                            }
                        }, destinationView: AnyView(EditEmergencyContactView(emergencyContacts: $emergencyContacts)))
                        
                        SectionView(title: "Button Messages", content:  {
                            InfoView(title: "Yellow\nButton", value: yellowMessage)
                            InfoView(title: "Red\nButton", value: redMessage)
                        }, destinationView: AnyView(EditButtonMessageView(yellowMessage: $yellowMessage, redMessage: $redMessage)))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct EditPersonalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var fullName: String
    @Binding var phoneNumber: String
    @Binding var emailAddress: String
    
    @State private var newPhoneNumber: String = ""
    @State private var newEmailAddress: String = ""
    
    @State private var isPhoneNumberValid: Bool = true
    @State private var isEmailAddressValid: Bool = true
    
    @State private var smsVerificationCode: String = ""
    @State private var smsVerificationCodeSent: String = ""
    @State private var emailVerificationCode: String = ""
    @State private var emailVerificationCodeSent: String = ""
    
    @State private var smsVerificationEnabled: Bool = false
    @State private var smsVerificationValid: Bool = true
    @State private var emailVerificationEnabled: Bool = false
    @State private var emailVerificationValid: Bool = true
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text(fullName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Text("Enter New Phone Number")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        HStack(spacing: 10) {
                            Text("+1")
                            ZStack(alignment: .leading) {
                                TextField("", text: $newPhoneNumber)
                                //                                    .keyboardType(.numberPad)
                                
                                if newPhoneNumber.isEmpty {
                                    Text(phoneNumber)
                                        .opacity(0.5)
                                }
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: isPhoneNumberValid ? 2.5 : 0
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: isPhoneNumberValid ? 0 : 2.5)
                        )
                        .padding(.horizontal, 20)
                        .disabled(smsVerificationEnabled)
                        
                        if !isPhoneNumberValid {
                            Text("Please enter a valid phone number!")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        if smsVerificationEnabled {
                            ZStack(alignment: .leading) {
                                TextField("Verification Code", text: $smsVerificationCode)
                                //                                    .keyboardType(.numberPad)
                                
                                if smsVerificationCode.isEmpty {
                                    Text("Verification Code")
                                        .opacity(0.5)
                                }
                            }
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: smsVerificationValid ? 2.5 : 0
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: smsVerificationValid ? 0 : 2.5)
                            )
                            .padding(.horizontal, 20)
                            
                            if !smsVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newPhoneNumber.isEmpty {
                            Button(action: {
                                isPhoneNumberValid = InputValidator.validatePhoneNumber(newPhoneNumber)
                                if isPhoneNumberValid {
                                    if smsVerificationEnabled && smsVerificationCode == smsVerificationCodeSent {
                                        smsVerificationEnabled = false
                                        smsVerificationValid = true
                                        smsVerificationCode = ""
                                        phoneNumber = newPhoneNumber
                                        newPhoneNumber = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } else if smsVerificationEnabled {
                                        smsVerificationValid = false
                                    } else {
                                        smsVerificationEnabled = true
                                        smsVerificationCodeSent = InputVerifier.sendVerificationCodeViaSMS(to: newPhoneNumber)
                                    }
                                }
                            }) {
                                HStack {
                                    Text(smsVerificationEnabled ? "Save" : "Verify")
                                    Image(systemName: smsVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
                                }
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(12.5)
                                .frame(maxWidth: .infinity)
                                .background(.blue)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Text("Enter New Email Address")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        ZStack(alignment: .leading) {
                            TextField("", text: $newEmailAddress)
                                .autocapitalization(.none)
                            //                                .keyboardType(.emailAddress)
                            
                            if newEmailAddress.isEmpty {
                                Text(emailAddress)
                                    .opacity(0.5)
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: isEmailAddressValid ? 2.5 : 0
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: isEmailAddressValid ? 0 : 2.5)
                        )
                        .padding(.horizontal, 20)
                        .disabled(emailVerificationEnabled)
                        
                        if !isEmailAddressValid {
                            Text("Please enter a valid email address!")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        if emailVerificationEnabled {
                            ZStack(alignment: .leading) {
                                TextField("Verification Code", text: $emailVerificationCode)
                                //                                    .keyboardType(.numberPad)
                                
                                if emailVerificationCode.isEmpty {
                                    Text("Verification Code")
                                        .opacity(0.5)
                                }
                            }
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: emailVerificationValid ? 2.5 : 0
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: emailVerificationValid ? 0 : 2.5)
                            )
                            .padding(.horizontal, 20)
                            
                            if !emailVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newEmailAddress.isEmpty {
                            Button(action: {
                                isEmailAddressValid = InputValidator.validateEmail(newEmailAddress)
                                if isEmailAddressValid {
                                    if emailVerificationEnabled && emailVerificationCode == emailVerificationCodeSent {
                                        emailVerificationEnabled = false
                                        emailVerificationValid = true
                                        emailVerificationCode = ""
                                        emailAddress = newEmailAddress
                                        newEmailAddress = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } else if emailVerificationEnabled {
                                        emailVerificationValid = false
                                    } else {
                                        emailVerificationEnabled = true
                                        emailVerificationCodeSent = InputVerifier.sendVerificationCodeViaEmail(to: newEmailAddress)
                                    }
                                }
                            }) {
                                HStack {
                                    Text(emailVerificationEnabled ? "Save" : "Verify")
                                    Image(systemName: emailVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
                                }
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(12.5)
                                .frame(maxWidth: .infinity)
                                .background(.blue)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    if !(newPhoneNumber.isEmpty && newEmailAddress.isEmpty) {
                        if smsVerificationEnabled && smsVerificationCode == smsVerificationCodeSent {
                            smsVerificationEnabled = false
                            smsVerificationValid = true
                            smsVerificationCode = ""
                            phoneNumber = newPhoneNumber
                            newPhoneNumber = ""
                        } else {
                            alert = true
                            alertMessage = "You have not verified your new phone number!"
                            return
                        }
                        if emailVerificationEnabled && emailVerificationCode == emailVerificationCodeSent {
                            emailVerificationEnabled = false
                            emailVerificationValid = true
                            emailVerificationCode = ""
                            emailAddress = newEmailAddress
                            newEmailAddress = ""
                        } else {
                            alert = true
                            alertMessage = "You have not verified your new email address!"
                            return
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save and Exit")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditEmergencyContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var emergencyContacts: [EmergencyContact]
    
    @State private var newEmergencyContacts: [EmergencyContact]
    init(emergencyContacts: Binding<[EmergencyContact]>) {
        _emergencyContacts = emergencyContacts
        _newEmergencyContacts = State(initialValue: emergencyContacts.wrappedValue)
    }

    @State private var areEmergencyContactsValid: Bool = true
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Emergency Contacts")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                
                Spacer()
                
                Text("Choose New Emergency Contacts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        EmergencyContactPicker(contact: $newEmergencyContacts[index])
                            .font(.title3)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 2.5
                                    )
                            )
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 20)
                
                if !areEmergencyContactsValid {
                    Text("Please choose three unique emergency contacts!")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    areEmergencyContactsValid = InputValidator.validateEmergencyContacts(newEmergencyContacts)
                    if areEmergencyContactsValid {
                        emergencyContacts = newEmergencyContacts
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alert = true
                        alertMessage = "You have not chosen three unique emergency contacts!"
                    }
                }) {
                    Text("Save and Exit")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditButtonMessageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var yellowMessage: String
    @Binding var redMessage: String
    
    @State private var editYellowMessage: Bool = false
    @State private var editRedMessage: Bool = false
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Button Messages")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                
                Spacer()
                
                Text("Edit Yellow Button Message")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Button(action: {
                    editYellowMessage = true
                }) {
                    Text(yellowMessage)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(12.5)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 2.5
                                )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $editYellowMessage) {
                    EditYellowMessageView(yellowMessage: $yellowMessage, editYellowMessage: $editYellowMessage)
                }
                
                Text("Edit Red Button Message")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Button(action: {
                    editRedMessage = true
                }) {
                    Text(redMessage)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(12.5)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 2.5
                                )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $editRedMessage) {
                    EditRedMessageView(redMessage: $redMessage, editRedMessage: $editRedMessage)
                }
                
                Spacer()
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save and Exit")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditYellowMessageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var yellowMessage: String
    @Binding var editYellowMessage: Bool
    
    @FocusState private var isEditing: Bool
    @State private var messageTemplates: [String] = [
        "I'm heading out and would feel safer if someone kept an eye on my journey. Would you mind monitoring my live location?",
        "I'm about to take a trip that I'm not entirely comfortable with. Could you accompany me virtually by keeping tabs on my live location?",
        "Just letting you know, I'm out alone right now and it would put me at ease if you could check up on me periodically. You've been sent my live location.",
    ]
    @State private var selectedTemplate: Int?
    @State private var editingTemplate: Int?
    @State private var customMessage: String = ""
    
    @State private var valid: Bool = true
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var viewLoaded: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Yellow Message")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                
                Spacer()
                
                Text("Edit Yellow Button Message")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack(spacing: 15) {
                    if editingTemplate != nil {
                        VStack {
                            TextEditor(text: $messageTemplates[editingTemplate!])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .padding(12.5)
                                .background(.white)
                                .colorScheme(.light)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .red],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 2.5
                                        )
                                )
                                .focused($isEditing)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                        
                        HStack {
                            Button("Select", action: {
                                selectedTemplate = editingTemplate
                                editingTemplate = nil
                                isEditing = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Button("Cancel", action: {
                                editingTemplate = nil
                                isEditing = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                    } else {
                        ForEach(0..<messageTemplates.count, id: \.self) { index in
                            TextField("Placeholder", text: Binding(
                                get: { self.messageTemplates[index] },
                                set: { newValue in
                                    self.messageTemplates[index] = newValue
                                    self.selectedTemplate = nil
                                    self.customMessage = ""
                                }
                            ))
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .frame(maxWidth: .infinity)
                            .background(selectedTemplate == index ? .white.opacity(0.5) : .white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: selectedTemplate == index ? 2.5 : 0
                                    )
                            )
                            .onTapGesture {
                                self.editingTemplate = index
                                self.isEditing = true
                            }
                        }
                        
                        ZStack(alignment: .leading) {
                            if customMessage.isEmpty {
                                Text(yellowMessage)
                                    .lineLimit(1)
                                    .opacity(0.5)
                            }
                            
                            TextField("", text: Binding(
                                get: { self.customMessage },
                                set: { newValue in
                                    self.customMessage = newValue
                                    self.selectedTemplate = nil
                                }
                            ))
                            .onAppear() {
                                if !viewLoaded {
                                    customMessage = yellowMessage
                                    viewLoaded = true
                                }
                            }
                        }
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(!customMessage.isEmpty ? .white.opacity(0.5) : .white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: !customMessage.isEmpty ? 2.5 : 0
                                )
                        )
                    }
                    
                    if !valid {
                        Text("Please choose a template or create your own!")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    valid = (selectedTemplate != nil && !messageTemplates[selectedTemplate!].isEmpty) || !customMessage.isEmpty
                    if valid {
                        yellowMessage = selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage
                        editYellowMessage = false
                        viewLoaded = false
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alert = true
                        alertMessage = "You have not chosen and optionally editted a message template or edited your own custom message!"
                    }
                }) {
                    HStack {
                        Text("Save")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditRedMessageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var redMessage: String
    @Binding var editRedMessage: Bool
    
    @FocusState private var isSelecting: Bool
    @State private var messageTemplates: [String] = [
        "URGENT: I am in an immediate crisis and need your assistance. Please contact authorities or come help me. My live location has been sent to you.",
        "EMERGENCY ALERT: I am in serious danger and unable to call 911. Please, notify local authorities immediately. Check my live location for my whereabouts.",
        "CRISIS ALERT: I am in a high-risk situation and unable to reach out to the police. I need immediate assistance. Please, contact the authorities and come help. My live location is shared with you.",
    ]
    @State private var selectedTemplate: Int?
    @State private var selectingTemplate: Int?
    
    @State private var valid: Bool = true
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Red Message")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                
                Spacer()
                
                Text("Edit Red Button Message")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack(spacing: 15) {
                    if selectingTemplate != nil {
                        VStack {
                            Text(messageTemplates[selectingTemplate!])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(12.5)
                                .background(.white)
                                .colorScheme(.light)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .red],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 2.5
                                        )
                                )
                                .focused($isSelecting)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Spacer()
                        }
                        .frame(height: 150)
                        
                        HStack {
                            Button("Select", action: {
                                selectedTemplate = selectingTemplate
                                selectingTemplate = nil
                                isSelecting = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Button("Cancel", action: {
                                selectingTemplate = nil
                                isSelecting = false
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                    } else {
                        ForEach(0..<messageTemplates.count, id: \.self) { index in
                            TextField("Placeholder", text: Binding(
                                get: { self.messageTemplates[index] },
                                set: { newValue in
                                    self.messageTemplates[index] = newValue
                                    self.selectedTemplate = nil
                                }
                            ))
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .frame(maxWidth: .infinity)
                            .background(selectedTemplate == index ? .white.opacity(0.5) : .white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: selectedTemplate == index ? 2.5 : 0
                                    )
                            )
                            .onTapGesture {
                                self.selectingTemplate = index
                                self.isSelecting = true
                            }
                        }
                    }
                    
                    if !valid {
                        Text("Please choose a template")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    valid = selectedTemplate != nil
                    if valid {
                        redMessage = messageTemplates[selectedTemplate!]
                        editRedMessage = false
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alert = true
                        alertMessage = "You have not chosen a message template!"
                    }
                }) {
                    HStack {
                        Text("Save")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    @State static var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(isSelected: true, displayName: "John Doe", phoneNumber: "+1 (234) 567-8901"),
        EmergencyContact(isSelected: true, displayName: "Jane Doe", phoneNumber: "+1 (234) 567-8902"),
        EmergencyContact(isSelected: true, displayName: "Baby Doe", phoneNumber: "+1 (234) 567-8903")
    ]
    @State static var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    @State static var redMessage: String = "I'm feeling a bit unsafe, can you check on me"
    
    @State static var editYellowMessage: Bool = true
    @State static var editRedMessage: Bool = false
    
    static var previews: some View {
        ProfileView()
        EditPersonalView(fullName: $fullName, phoneNumber: $phoneNumber, emailAddress: $emailAddress)
        EditEmergencyContactView(emergencyContacts: $emergencyContacts)
        EditButtonMessageView(yellowMessage: $yellowMessage, redMessage: $redMessage)
        EditYellowMessageView(yellowMessage: $yellowMessage, editYellowMessage: $editYellowMessage)
        EditRedMessageView(redMessage: $redMessage, editRedMessage: $editRedMessage)
    }
}
