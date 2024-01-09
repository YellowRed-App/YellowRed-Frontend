//
//  GetStartedNumberView.swift
//  YellowRed
//
//  Created by Krish Mehta on 29/5/23.
//

import SwiftUI

struct GetStartedNumberView: View {
    @State private var phoneNumber: String = ""
    
    @ObservedObject var validator = InputValidator()
    @ObservedObject var verifier = InputVerifier()
    
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
                
                Text("Enter Phone Number")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                HStack(spacing: 10) {
                    Text("+1")
                    ZStack(alignment: .leading) {
                        if phoneNumber.isEmpty {
                            Text("(123) 456-7890")
                                .opacity(0.5)
                        }
                        
                        TextField("(123) 456-7890", text: $phoneNumber)
                            .onReceive(phoneNumber.publisher.collect()) {
                                let number = String($0)
                                if let formattedNumber = PhoneNumberFormatter.format(phone: number) {
                                    phoneNumber = formattedNumber
                                }
                            }
                        //                            .keyboardType(.numberPad)
                    }
                }
                .font(.title3)
                .foregroundColor(.black)
                .padding(12.5)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: validator.isPhoneNumberValid ? 0 : 2.5)
                )
                .disabled(verifier.isVerificationEnabled)
                
                if !validator.isPhoneNumberValid {
                    Text("Please enter a valid phone number!")
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
                    validator.validatePhoneNumber(phoneNumber)
                    if validator.isPhoneNumberValid {
                        if verifier.isVerificationEnabled {
                            verifier.verifyVerificationCode(verifier.verificationCode)
                        } else {
                            verifier.isVerificationEnabled = true
                            verifier.sendVerificationCode(to: "+1\(phoneNumber)")
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
                        destination: GetStartedEmailView(fullName: fullName, phoneNumber: phoneNumber),
                        isActive: $verifier.next,
                        label: { EmptyView() }
                    )
                )
                
                VStack(spacing: 10) {
                    if verifier.isVerificationEnabled {
                        Button(action: {
                            if !verifier.cooldown {
                                verifier.resendVerificationCode(to: phoneNumber)
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
        .alert(isPresented: $verifier.alert) {
            Alert(title: Text("Error"), message: Text(verifier.alertMessage), dismissButton: .default(Text("OK")))
        }
        .endEditingOnTap()
    }
}

struct GetStartedNumberView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    
    static var previews: some View {
        GetStartedNumberView(fullName: fullName)
    }
}
