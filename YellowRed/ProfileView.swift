//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 7/1/23.
//  Revamped by Krish Mehta on 4/7/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var userViewModel = UserViewModel()
    
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
                        
                        Text(userViewModel.fullName)
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
                            InfoView(title: "Phone Number", value: userViewModel.phoneNumber)
                            InfoView(title: "Email Address", value: userViewModel.emailAddress)
                        }, destinationView: AnyView(EditPersonalView(userViewModel: userViewModel)))
                        SectionView(title: "Emergency Contacts", content:  {
                            ForEach(userViewModel.emergencyContacts.indices, id: \.self) { index in
                                InfoView(title: "Contact \(index + 1)", value: "\(userViewModel.emergencyContacts[index].displayName)")
                            }
                        }, destinationView: AnyView(EditEmergencyContactView(userViewModel: userViewModel)))
                        
                        SectionView(title: "Button Messages", content:  {
                            InfoView(title: "Yellow\t", value: userViewModel.yellowMessage)
                            InfoView(title: "Red\t", value: userViewModel.redMessage)
                        }, destinationView: AnyView(EditButtonMessageView(userViewModel: userViewModel)))
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onAppear {
            fetchAllData()
        }
    }
    
    private func fetchAllData() {
        if let userUID = Auth.auth().currentUser?.uid {
            userViewModel.fetchUserData(userId: userUID) { userDataResult in
                switch userDataResult {
                case .success:
                    self.userViewModel.fetchEmergencyContacts(userId: userUID) { emergencyContactsResult in
                        switch emergencyContactsResult {
                        case .success:
                            self.userViewModel.fetchYellowRedMessages(userId: userUID) { yellowRedMessagesResult in
                                switch yellowRedMessagesResult {
                                case .success:
                                    // All data is fetched, and the view can be updated.
                                    // The UI will react to changes since the userViewModel properties are @Published.
                                    print("Success fetching yellow/red messages.")
                                case .failure(let error):
                                    print("Error fetching yellow/red messages: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            print("Error fetching emergency contacts: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct EditPersonalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var newPhoneNumber: String = ""
    @State private var newEmailAddress: String = ""
    
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
                    
                    Text(userViewModel.fullName)
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
                                if newPhoneNumber.isEmpty {
                                    Text(userViewModel.phoneNumber)
                                        .opacity(0.5)
                                }
                                
                                TextField("", text: $newPhoneNumber)
                                    .onReceive(newPhoneNumber.publisher.collect()) {
                                        let number = String($0)
                                        if let formattedNumber = PhoneNumberFormatter.format(phone: number) {
                                            self.newPhoneNumber = formattedNumber
                                        }
                                    }
                                //                                    .keyboardType(.numberPad)
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
                        .disabled(phoneVerifier.isVerificationEnabled)
                        
                        if !validator.isPhoneNumberValid {
                            Text("Please enter a valid phone number!")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        if phoneVerifier.isVerificationEnabled {
                            ZStack(alignment: .leading) {
                                if phoneVerifier.verificationCode.isEmpty {
                                    Text("Verification Code")
                                        .opacity(0.5)
                                }
                                
                                TextField("Verification Code", text: $phoneVerifier.verificationCode)
                                //                                    .keyboardType(.numberPad)
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
                                        ), lineWidth: phoneVerifier.isVerificationValid ? 2.5 : 0
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: phoneVerifier.isVerificationValid ? 0 : 2.5)
                            )
                            
                            if !phoneVerifier.isVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newPhoneNumber.isEmpty {
                            Button(action: {
                                validator.validatePhoneNumber(newPhoneNumber)
                                if validator.isPhoneNumberValid {
                                    if phoneVerifier.isVerificationEnabled {
                                        phoneVerifier.verifyVerificationCode(phoneVerifier.verificationCode)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            if phoneVerifier.isVerificationValid {
                                                if let userUID = Auth.auth().currentUser?.uid {
                                                    userViewModel.updateUser(userId: userUID, phoneNumber: newPhoneNumber, emailAddress: userViewModel.emailAddress) { result in
                                                        switch result {
                                                        case .success:
                                                            userViewModel.phoneNumber = newPhoneNumber
                                                            newPhoneNumber = ""
                                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                        case .failure:
                                                            alert = true
                                                            alertMessage = "Failed to update phone number."
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        phoneVerifier.isVerificationEnabled = true
                                        phoneVerifier.sendVerificationCode(to: "+1\(newPhoneNumber)")
                                    }
                                }
                            }) {
                                HStack {
                                    Text(phoneVerifier.isVerificationEnabled ? "Save" : "Verify")
                                    Image(systemName: phoneVerifier.isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
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
                            if phoneVerifier.isVerificationEnabled {
                                Button(action: {
                                    if !phoneVerifier.cooldown {
                                        phoneVerifier.resendVerificationCode(to: "+1\(newPhoneNumber)")
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
                            if newEmailAddress.isEmpty {
                                Text(userViewModel.emailAddress)
                                    .opacity(0.5)
                            }
                            
                            TextField("", text: $newEmailAddress)
                                .autocapitalization(.none)
                            //                                .keyboardType(.emailAddress)
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
                        .disabled(emailVerifier.isVerificationEnabled)
                        
                        if !validator.isEmailAddressValid {
                            Text("Please enter a valid email address!")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        if emailVerifier.isVerificationEnabled {
                            ZStack(alignment: .leading) {
                                if emailVerifier.verificationCode.isEmpty {
                                    Text("Verification Code")
                                        .opacity(0.5)
                                }
                                
                                TextField("Verification Code", text: $emailVerifier.verificationCode)
                                //                                    .keyboardType(.numberPad)
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
                                        ), lineWidth: emailVerifier.isVerificationValid ? 2.5 : 0
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: emailVerifier.isVerificationValid ? 0 : 2.5)
                            )
                            
                            if !emailVerifier.isVerificationValid {
                                Text("Invalid verification code. Please try again!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if !newEmailAddress.isEmpty {
                            Button(action: {
                                validator.validateEmailAddress(newEmailAddress)
                                if validator.isEmailAddressValid {
                                    if emailVerifier.isVerificationEnabled {
                                        emailVerifier.verifyVerificationCodeViaEmail(emailVerifier.verificationCode)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            if emailVerifier.isVerificationValid {
                                                if let userUID = Auth.auth().currentUser?.uid {
                                                    userViewModel.updateUser(userId: userUID, phoneNumber: userViewModel.phoneNumber, emailAddress: newEmailAddress) { result in
                                                        switch result {
                                                        case .success:
                                                            userViewModel.emailAddress = newEmailAddress
                                                            newEmailAddress = ""
                                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                        case .failure:
                                                            alert = true
                                                            alertMessage = "Failed to update email address."
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        emailVerifier.isVerificationEnabled = true
                                        emailVerifier.sendVerificationCodeViaEmail(to: newEmailAddress)
                                    }
                                }
                            }) {
                                HStack {
                                    Text(emailVerifier.isVerificationEnabled ? "Save" : "Verify")
                                    Image(systemName: emailVerifier.isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
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
                            if emailVerifier.isVerificationEnabled {
                                Button(action: {
                                    if !emailVerifier.cooldown {
                                        emailVerifier.resendVerificationCodeViaEmail(to: newEmailAddress)
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
                        if phoneVerifier.isVerificationEnabled && phoneVerifier.isVerificationValid {
                            phoneVerifier.isVerificationEnabled = false
                            phoneVerifier.isVerificationValid = true
                            phoneVerifier.verificationCode = ""
                            userViewModel.phoneNumber = newPhoneNumber
                            newPhoneNumber = ""
                        } else {
                            alert = true
                            alertMessage = "You have not verified your new phone number!"
                            return
                        }
                        if emailVerifier.isVerificationEnabled && emailVerifier.isVerificationValid {
                            emailVerifier.isVerificationEnabled = false
                            emailVerifier.isVerificationValid = true
                            emailVerifier.verificationCode = ""
                            userViewModel.emailAddress = newEmailAddress
                            newEmailAddress = ""
                        } else {
                            alert = true
                            alertMessage = "You have not verified your new phone number!"
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
    
    @ObservedObject var userViewModel: UserViewModel
    
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
                        EmergencyContactPicker(contact: $userViewModel.emergencyContacts[index])
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
                    validator.validateEmergencyContacts(userViewModel.emergencyContacts)
                    if validator.emergencyContactsSelected.count == 3 && validator.emergencyContactsDuplicated.isEmpty {
                        if let userUID = Auth.auth().currentUser?.uid {
                            userViewModel.updateEmergencyContacts(userId: userUID, emergencyContacts: userViewModel.emergencyContacts, completion: { result in
                                switch result {
                                case .success:
                                    presentationMode.wrappedValue.dismiss()
                                case .failure:
                                    alert = true
                                    alertMessage = "Failed to update emergency contacts."
                                }
                            })
                        }
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
        .onAppear {
            for index in userViewModel.emergencyContacts.indices {
                userViewModel.emergencyContacts[index].isSelected = true
            }
        }
    }
}

struct EditButtonMessageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userViewModel: UserViewModel
    
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
                    Text(userViewModel.yellowMessage)
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
                    EditYellowMessageView(userViewModel: userViewModel, editYellowMessage: $editYellowMessage)
                }
                
                Text("Edit Red Button Message")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Button(action: {
                    editRedMessage = true
                }) {
                    Text(userViewModel.redMessage)
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
                    EditRedMessageView(userViewModel: userViewModel, editRedMessage: $editRedMessage)
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
    
    @ObservedObject var userViewModel: UserViewModel
    
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
                                Text(userViewModel.yellowMessage)
                                    .lineLimit(1)
                                    .opacity(0.5)
                            }
                            
                            HStack {
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
                                        customMessage = userViewModel.yellowMessage
                                        viewLoaded = true
                                    }
                                }
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .padding(12.5)
                                .frame(maxWidth: .infinity)
                                
                                if !customMessage.isEmpty {
                                    Button(action: {
                                        self.customMessage = ""
                                        self.selectedTemplate = self.previousSelectedTemplate
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                            .background(customMessage.isEmpty ? .white : .white.opacity(0.5))
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
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                if !isEditing && editingTemplate == nil {
                    Button(action: {
                        valid = (selectedTemplate != nil && !messageTemplates[selectedTemplate!].isEmpty) || !customMessage.isEmpty
                        if valid {
                            if let userUID = Auth.auth().currentUser?.uid {
                                userViewModel.updateYellowRedMessages(userId: userUID, yellowMessage: selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage, redMessage: userViewModel.redMessage) { result in
                                    switch result {
                                    case .success:
                                        userViewModel.yellowMessage = selectedTemplate != nil ? messageTemplates[selectedTemplate!] : customMessage
                                        editYellowMessage = false
                                        viewLoaded = false
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure:
                                        error = true
                                        alert = true
                                        alertMessage = "Failed to update yellow message."
                                    }
                                }
                            }
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
    
    @ObservedObject var userViewModel: UserViewModel
    
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
                            if let userUID = Auth.auth().currentUser?.uid {
                                userViewModel.updateYellowRedMessages(userId: userUID, yellowMessage: userViewModel.yellowMessage, redMessage: messageTemplates[selectedTemplate!]) { result in
                                    switch result {
                                    case .success:
                                        userViewModel.redMessage = messageTemplates[selectedTemplate!]
                                        editRedMessage = false
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure:
                                        error = true
                                        alert = true
                                        alertMessage = "Failed to update red message."
                                    }
                                }
                            }
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
    static var previews: some View {
        ProfileView()
        EditPersonalView(userViewModel: UserViewModel())
        EditEmergencyContactView(userViewModel: UserViewModel())
        EditButtonMessageView(userViewModel: UserViewModel())
        EditYellowMessageView(userViewModel: UserViewModel(), editYellowMessage: Binding.constant(true))
        EditRedMessageView(userViewModel: UserViewModel(), editRedMessage: Binding.constant(false))
    }
}
