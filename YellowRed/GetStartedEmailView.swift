//
//  GetStartedEmailView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedEmailView: View {
    @State private var emailAddress: String = ""
    
    @ObservedObject var validator = InputValidator()
    @ObservedObject var verifier = InputVerifier()
    
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
                    if emailAddress.isEmpty {
                        Text("abc5xy@virginia.edu")
                            .accentColor(.black)
                            .opacity(0.5)
                    }
                    
                    TextField("", text: $emailAddress)
                        .autocapitalization(.none)
                    //                        .keyboardType(.emailAddress)
                }
                .font(.title3)
                .foregroundColor(.black)
                .padding(12.5)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: validator.isEmailAddressValid ? 0 : 2.5)
                )
                .disabled(verifier.isVerificationEnabled)
                
                if !validator.isEmailAddressValid {
                    Text("Please enter a valid email address!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if verifier.isVerificationEnabled {
                    ZStack(alignment: .leading) {
                        if verifier.verificationCode.isEmpty {
                            Text("Verification Code")
                                .opacity(0.5)
                        }
                        
                        TextField("Verification Code", text: $verifier.verificationCode)
                        //                            .keyboardType(.numberPad)
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(12.5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: verifier.isVerificationValid ? 0 : 2.5)
                    )
                    
                    if !verifier.isVerificationValid {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    validator.validateEmailAddress(emailAddress)
                    if validator.isEmailAddressValid {
                        if verifier.isVerificationEnabled {
                            verifier.verifyVerificationCodeViaEmail(verifier.verificationCode)
                        } else {
                            verifier.isVerificationEnabled = true
                            verifier.sendVerificationCodeViaEmail(to: emailAddress)
                        }
                    }
                }) {
                    HStack {
                        Text(verifier.isVerificationEnabled ? "Next" : "Verify")
                        Image(systemName: verifier.isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
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
                        isActive: $verifier.next,
                        label: { EmptyView() }
                    )
                )
                
                VStack(spacing: 10) {
                    if verifier.isVerificationEnabled {
                        Button(action: {
                            if !verifier.cooldown {
                                verifier.resendVerificationCodeViaEmail(to: emailAddress)
                            }
                        }) {
                            Text(verifier.cooldownTime > 0 ? "Code Resent" : "Resend Code")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(.blue)
                        }
                        
                        if verifier.cooldownTime > 0 {
                            Text("Try again in \(verifier.cooldownTime) seconds")
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
