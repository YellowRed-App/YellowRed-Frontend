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
    @State private var yellowMessage: String = "I'm out and about, and I could use a virtual buddy to keep an eye on my location. You've been sent my live location, and I would appreciate it if you could check in on me from time to time."
    @State private var redMessage: String = "IMMEDIATE HELP NEEDED: I am in a threatening situation and unable to dial 911. Your immediate action is required. Please alert the authorities and come help, if possible. My current location is shared with you."
    
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
                                InfoView(title: "Contact \(index + 1)", value: "\(emergencyContacts[index].displayName)")
                            }
                        }, destinationView: AnyView(EditEmergencyContactView(emergencyContacts: $emergencyContacts)))
                        
                        SectionView(title: "Button Messages", content:  {
                            InfoView(title: "Yellow\t", value: yellowMessage)
                            InfoView(title: "Red\t", value: redMessage)
                        }, destinationView: AnyView(EditButtonMessageView(yellowMessage: $yellowMessage, redMessage: $redMessage)))
                    }
                    .padding(.horizontal, 20)
                    Spacer()
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
    
    @ObservedObject private var validator = InputValidator()
    @ObservedObject private var phoneVerifier = InputVerifier()
    @ObservedObject private var emailVerifier = InputVerifier()
    
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
                                    .onReceive(newPhoneNumber.publisher.collect()) {
                                        let number = String($0)
                                        if let formattedNumber = PhoneNumberFormatter.format(phone: number) {
                                            self.newPhoneNumber = formattedNumber
                                        }
                                    }
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
                                    ), lineWidth: validator.isPhoneNumberValid ? 2.5 : 0
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: validator.isPhoneNumberValid ? 0 : 2.5)
                        )
                        .disabled(smsVerificationEnabled)
                        
                        if !validator.isPhoneNumberValid {
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
                            
                            if !smsVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newPhoneNumber.isEmpty {
                            Button(action: {
                                validator.validatePhoneNumber(newPhoneNumber)
                                if validator.isPhoneNumberValid {
                                    if smsVerificationEnabled && smsVerificationCode ==
                                        smsVerificationCodeSent {
                                        smsVerificationEnabled = false
                                        smsVerificationValid = true
                                        smsVerificationCode = ""
                                        phoneNumber = newPhoneNumber
                                        newPhoneNumber = ""
                                        phoneVerifier.stopCooldown()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } else if smsVerificationEnabled {
                                        smsVerificationValid = false
                                    } else {
                                        smsVerificationEnabled = true
                                        smsVerificationCodeSent = phoneVerifier.sendVerificationCodeViaSMS(to: newPhoneNumber)
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
                        }
                        
                        VStack(spacing: 10) {
                            if smsVerificationEnabled {
                                Button(action: {
                                    if !phoneVerifier.cooldown {
                                        smsVerificationCodeSent = phoneVerifier.resendVerificationCodeViaSMS(to: newPhoneNumber)
                                    }
                                }) {
                                    Text(phoneVerifier.cooldownTime > 0 ? "Code Resent" : "Resend Code")
                                        .font(.body)
                                        .fontWeight(.regular)
                                        .foregroundColor(.blue)
                                }
                                
                                if phoneVerifier.cooldownTime > 0 {
                                    Text("Try again in \(phoneVerifier.cooldownTime) seconds")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(.blue)
                                }
                            }
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
                                    ), lineWidth: validator.isEmailAddressValid ? 2.5 : 0
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: validator.isEmailAddressValid ? 0 : 2.5)
                        )
                        .disabled(emailVerificationEnabled)
                        
                        if !validator.isEmailAddressValid {
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
                            
                            if !emailVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newEmailAddress.isEmpty {
                            Button(action: {
                                validator.validateEmailAddress(newEmailAddress)
                                if validator.isEmailAddressValid {
                                    if emailVerificationEnabled && emailVerificationCode == emailVerificationCodeSent {
                                        emailVerificationEnabled = false
                                        emailVerificationValid = true
                                        emailVerificationCode = ""
                                        emailAddress = newEmailAddress
                                        newEmailAddress = ""
                                        emailVerifier.stopCooldown()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } else if emailVerificationEnabled {
                                        emailVerificationValid = false
                                    } else {
                                        emailVerificationEnabled = true
                                        emailVerificationCodeSent = emailVerifier.sendVerificationCodeViaEmail(to: newEmailAddress)
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
                        }
                        
                        VStack(spacing: 10) {
                            if emailVerificationEnabled {
                                Button(action: {
                                    if !emailVerifier.cooldown {
                                        emailVerificationCodeSent = emailVerifier.resendVerificationCodeViaEmail(to: newEmailAddress)
                                    }
                                }) {
                                    Text(emailVerifier.cooldownTime > 0 ? "Code Resent" : "Resend Code")
                                        .font(.body)
                                        .fontWeight(.regular)
                                        .foregroundColor(.blue)
                                }
                                
                                if emailVerifier.cooldownTime > 0 {
                                    Text("Try again in \(emailVerifier.cooldownTime) seconds")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 40)
                }
                .padding(.horizontal, 40)
                
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
        .endEditingOnTap()
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
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var saveButtonClicked: Bool = false
    
    @ObservedObject private var validator = InputValidator()
    
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
                                        ), lineWidth: 2.5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: saveButtonClicked && (!validator.emergencyContactsSelected.contains(index) || validator.emergencyContactsDuplicated.contains(index)) ? 2.5 : 0)
                            )
                            .padding(.vertical, 5)
                    }
                }
                
                if saveButtonClicked && validator.emergencyContactsSelected.count != 3 {
                    Text("Please choose three emergency contacts!")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                if !validator.emergencyContactsDuplicated.isEmpty {
                    Text("Please choose three unique emergency contacts!")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    saveButtonClicked = true
                    validator.validateEmergencyContacts(emergencyContacts)
                    if validator.emergencyContactsSelected.count == 3 && validator.emergencyContactsDuplicated.isEmpty {
                        emergencyContacts = newEmergencyContacts
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alert = true
                        if validator.emergencyContactsSelected.count != 3 {
                            alertMessage = "You have not chosen three emergency contacts!"
                        }
                        if !validator.emergencyContactsDuplicated.isEmpty {
                            alertMessage = "You have not chosen three unique emergency contacts!"
                        }
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
                }
                .padding(.horizontal, 40)
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
                }
                .padding(.horizontal, 40)
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
    @State private var editingTemplate: Int?
    @State private var selectedTemplate: Int?
    @State private var previousSelectedTemplate: Int?
    @State private var customMessage: String = ""
    @State private var previousCustomMessage: String = ""
    
    @State private var valid: Bool = true
    @State private var error: Bool = false
    
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
                                previousSelectedTemplate = selectedTemplate
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                            
                            Button("Cancel", action: {
                                editingTemplate = nil
                                isEditing = false
                                customMessage = previousCustomMessage
                                if previousCustomMessage.isEmpty {
                                    selectedTemplate = previousSelectedTemplate
                                } else {
                                    selectedTemplate = nil
                                }
                            })
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
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
                                self.previousSelectedTemplate = self.selectedTemplate
                                self.previousCustomMessage = self.customMessage
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
                                    self.previousCustomMessage = customMessage
                                    self.selectedTemplate = nil
                                    self.previousSelectedTemplate = nil
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
                    
                    if !isEditing && editingTemplate == nil {
                        if error {
                            Text("Please choose a template or create your own!")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        error = false
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                if !isEditing && editingTemplate == nil {
                    Button(action: {
                        valid = (selectedTemplate != nil && !messageTemplates[selectedTemplate!].isEmpty) || !customMessage.isEmpty
                        if valid {
                            yellowMessage = selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage
                            editYellowMessage = false
                            viewLoaded = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            error = true
                            alert = true
                            alertMessage = "You have not chosen and optionally edited a message template or edited your own custom message!"
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
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .endEditingOnTap()
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
    @State private var error: Bool = false
    
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
                        .frame(height: 200)
                        
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                            
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                    } else {
                        ForEach(0..<messageTemplates.count, id: \.self) { index in
                            Text(self.messageTemplates[index])
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .lineLimit(1)
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
                    
                    if !isSelecting && selectingTemplate == nil {
                        if error {
                            Text("Please choose a template")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        error = false
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                if !isSelecting && selectingTemplate == nil {
                    Button(action: {
                        valid = selectedTemplate != nil
                        if valid {
                            redMessage = messageTemplates[selectedTemplate!]
                            editRedMessage = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            error = true
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
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
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
