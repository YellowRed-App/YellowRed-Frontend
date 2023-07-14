//
//  GetStartedEmailView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedEmailView: View {
    @State private var emailAddress: String = ""
    @State private var isEmailAddressValid: Bool = true
    
    @State private var verificationCode: String = ""
    @State private var verificationCodeSent: String = ""
    
    @State private var isVerificationEnabled: Bool = false
    @State private var isVerificationValid: Bool = true
    
    @State private var next: Bool = false
    
    @ObservedObject var inputVerifier = InputVerifier()
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
    let phoneNumber: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Welcome, \(firstName)...")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Enter Email Address")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                ZStack(alignment: .leading) {
                    TextField("abc5xy@virginia.edu", text: $emailAddress)
                        .autocapitalization(.none)
                    //                        .keyboardType(.emailAddress)
                    
                    if emailAddress.isEmpty {
                        Text("abc5xy@virginia.edu")
                            .accentColor(.black)
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
                        .stroke(.black, lineWidth: isEmailAddressValid ? 0 : 2.5)
                )
                .disabled(isVerificationEnabled)
                
                if !isEmailAddressValid {
                    Text("Please enter a valid email address!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if isVerificationEnabled {
                    ZStack(alignment: .leading) {
                        TextField("Verification Code", text: $verificationCode)
                        //                            .keyboardType(.numberPad)
                        
                        if verificationCode.isEmpty {
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
                            .stroke(.black, lineWidth: isVerificationValid ? 0 : 2.5)
                    )
                    
                    if !isVerificationValid {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isEmailAddressValid = InputValidator.validateEmailAddress(emailAddress)
                    if isEmailAddressValid {
                        if isVerificationEnabled && verificationCode == verificationCodeSent {
                            inputVerifier.stopCooldown()
                            isVerificationValid = true
                            next = true
                        } else if isVerificationEnabled {
//                            isVerificationValid = false
                            // MARK: Temporary
                            inputVerifier.stopCooldown()
                            isVerificationValid = true
                            next = true
                        } else {
                            isVerificationEnabled = true
                            verificationCodeSent = inputVerifier.sendVerificationCodeViaEmail(to: phoneNumber)
                        }
                    }
                }) {
                    HStack {
                        Text(isVerificationEnabled ? "Next" : "Verify")
                        Image(systemName: isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
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
                .background(
                    NavigationLink(
                        destination: GetStartedAffiliationView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                
                VStack(spacing: 10) {
                    if isVerificationEnabled {
                        Button(action: {
                            if !inputVerifier.isCooldown {
                                verificationCodeSent = inputVerifier.resendVerificationCodeViaEmail(to: phoneNumber)
                            }
                        }) {
                            Text(inputVerifier.cooldownTime > 0 ? "Code Resent" : "Resend Code")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.blue)
                        }
                        
                        if inputVerifier.cooldownTime > 0 {
                            Text("Try again in \(inputVerifier.cooldownTime) seconds")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .endEditingOnTap()
    }
}

struct GetStartedEmailView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    
    static var previews: some View {
        GetStartedEmailView(fullName: fullName, phoneNumber: phoneNumber)
    }
}
