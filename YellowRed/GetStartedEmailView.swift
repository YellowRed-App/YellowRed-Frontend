//
//  GetStartedEmailView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedEmailView: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    
    @State private var verificationCode: String = ""
    @State private var verificationCodeSent: String = ""
    
    @State private var isVerificationEnabled: Bool = false
    @State private var isVerificationValid: Bool = true
    
    @State private var next: Bool = false
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
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
                
                Text("Enter Organization Email")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                ZStack(alignment: .leading) {
                    TextField("abc5xy@virginia.edu", text: $email)
                        .autocapitalization(.none)
//                        .keyboardType(.emailAddress)
                    
                    if email.isEmpty {
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
                        .stroke(.black, lineWidth: isEmailValid ? 0 : 2.5)
                )
                .padding(.horizontal, 20)
                .disabled(isVerificationEnabled)
                
                if !isEmailValid {
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
                    .padding(.horizontal, 20)
                    
                    if !isVerificationValid {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isEmailValid = InputValidator.validateEmail(email)
                    if isEmailValid {
                        if isVerificationEnabled && verificationCode == verificationCodeSent {
                            isVerificationValid = true
                            next = true
                        } else if isVerificationEnabled {
                            isVerificationValid = false
                        } else {
                            isVerificationEnabled = true
                            verificationCodeSent = InputVerifier.sendVerificationCodeViaEmail(to: email)
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
                .padding(.horizontal, 20)
                .background(
                    NavigationLink(
                        destination: GetStartedAffiliationView(fullName: fullName),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButton())
            }
            .padding(.horizontal, 20)
        }
    }
}

struct GetStartedEmailView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedEmailView(fullName: "John Smith")
    }
}
