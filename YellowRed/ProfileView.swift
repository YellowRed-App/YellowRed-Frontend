//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 7/1/23.
//  Edited by Krish Mehta on 4/7/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = "John Smith"
    @State private var phoneNumber: String = "(123) 456-7890"
    @State private var emailAddress: String = "abc5xy@virginia.edu"
    @State private var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(isSelected: false, displayName: "Contact 1", phoneNumber: "+1 (123) 456-7891"),
        EmergencyContact(isSelected: false, displayName: "Contact 2", phoneNumber: "+1 (123) 456-7892"),
        EmergencyContact(isSelected: false, displayName: "Contact 3", phoneNumber: "+1 (123) 456-7893")
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
                        }, destinationView: AnyView(EditEmergencyContactView()))
                        
                        SectionView(title: "Custom Messages", content:  {
                            InfoView(title: "Yellow\nButton", value: yellowMessage)
                            InfoView(title: "Red\nButton", value: redMessage)
                        }, destinationView: AnyView(EditCustomMessageView()))
                        
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

struct InfoView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct SectionView<Content: View>: View {
    @State private var next: Bool = false
    
    var title: String
    var content: Content
    var destinationView: AnyView?
    
    init(title: String, @ViewBuilder content: () -> Content, destinationView: AnyView? = nil) {
        self.title = title
        self.content = content()
        self.destinationView = destinationView
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if let destinationView = destinationView {
                        Button(action: {
                            next = true
                        }) {
                            Label("Edit", systemImage: "square.and.pencil")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }.sheet(isPresented: $next) {
                            destinationView
                        }
                    }
                }
                .padding(.bottom, 10)
                content
            }
            .padding()
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
                        ), lineWidth: 5
                    )
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
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
    
    var body: some View {
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
                        .foregroundColor(.white)
                        .padding(12.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isPhoneNumberValid ? 0 : 1)
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
                            .foregroundColor(.white)
                            .padding(12.5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: smsVerificationValid ? 0 : 1)
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
                        .foregroundColor(.white)
                        .padding(12.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isEmailAddressValid ? 0 : 1)
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
                            .foregroundColor(.white)
                            .padding(12.5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: emailVerificationValid ? 0 : 1)
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
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditEmergencyContactView: View {
    var body: some View {
        Text("Edit Emergency Contact View")
    }
}

struct EditCustomMessageView: View {
    var body: some View {
        Text("Edit Custom Message View")
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    static var previews: some View {
        ProfileView()
        EditPersonalView(fullName: $fullName, phoneNumber: $phoneNumber, emailAddress: $emailAddress)
        EditEmergencyContactView()
        EditCustomMessageView()
    }
}
