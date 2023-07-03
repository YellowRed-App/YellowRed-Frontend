//
//  GetStartedNumberView.swift
//  YellowRed
//
//  Created by Krish Mehta on 29/5/23.
//

import SwiftUI

struct GetStartedNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var phoneNumber: String = ""
    @State private var isPhoneNumberValid: Bool = true
    
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
                
                Text("Enter Phone Number")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                HStack(spacing: 10) {
                    Text("+1")
                    ZStack(alignment: .leading) {
                        TextField("(123) 456-7890", text: $phoneNumber)
                            .keyboardType(.numberPad)
                        
                        if phoneNumber.isEmpty {
                            Text("(123) 456-7890")
                                .opacity(0.5)
                        }
                    }
                }
                .font(.title3)
                .foregroundColor(.black)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: isPhoneNumberValid ? 0 : 1)
                )
                .padding(.horizontal, 20)
                .disabled(isVerificationEnabled)
                
                if !isPhoneNumberValid {
                    Text("Please enter a valid phone number!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if isVerificationEnabled {
                    TextField("Verification Code", text: $verificationCode)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isVerificationValid ? 0 : 1)
                        )
                        .padding(.horizontal, 20)
                    
                    if !isVerificationValid {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isPhoneNumberValid = validatePhoneNumber(phoneNumber)
                    if isPhoneNumberValid {
                        if isVerificationEnabled && verificationCode == verificationCodeSent {
                            isVerificationValid = true
                            next = true
                        } else if isVerificationEnabled {
                            isVerificationValid = false
                        } else {
                            isVerificationEnabled = true
                            sendVerificationCode()
                        }
                    }
                }) {
                    HStack {
                        Text(isVerificationEnabled ? "Next" : "Verify")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Image(systemName: isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 20)
                .background(
                    NavigationLink(
                        destination: GetStartedEmailView(fullName: fullName),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
            }
            .padding(.horizontal)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Back")
                    .foregroundColor(.white)
            }
        }
    }
    
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[2-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    private func sendVerificationCode() {
        // Generate a random six-digit code
        let randomCode = String(format: "%06d", Int.random(in: 0..<100000))
        
        // TODO: Implement code to send the verification code via SMS to the phoneNumber
        // For demonstration purposes, we'll print the code to the console
        print("Verification Code: \(randomCode)")
        
        // Update the verificationCodeSent with the generated code
        verificationCodeSent = randomCode
    }
}

struct GetStartedNumberView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNumberView(fullName: "John Smith")
    }
}
