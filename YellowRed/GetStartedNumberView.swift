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
    
    @State private var display: Bool = false
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
            
            VStack {
                Text("Welcome, \(firstName)...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
                
                Text("Enter Phone Number")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                VStack {
                    HStack(spacing: 0) {
                        Text("+1")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: 75)
                        
                        TextField("(123) 456-7890", text: $phoneNumber)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: 225)
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: isPhoneNumberValid ? 0 : 1)
                    )
                    .disabled(isVerificationEnabled)
                    
                    if !isPhoneNumberValid {
                        Text("Please enter a valid phone number!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                if isVerificationEnabled {
                    TextField("Verification Code", text: $verificationCode)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 300)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: display ? 1 : 0)
                        )
                    
                    if display {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isPhoneNumberValid = validatePhoneNumber(phoneNumber)
                    if isPhoneNumberValid {
                        if isVerificationEnabled && verificationCode == verificationCodeSent {
                            display = false
                            next = true
                        } else if isVerificationEnabled {
                            display = true
                        } else {
                            isVerificationEnabled = true
                            sendVerificationCode()
                        }
                    }
                }) {
                    Text(isVerificationEnabled ? "Next" : "Verify")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 100)
                        .background(.yellow)
                        .cornerRadius(10)
                }
                .padding()
                .cornerRadius(20)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .background(
                    NavigationLink(
                        destination: GetStartedEmailView(fullName: fullName),
                        isActive: $next,
                        label: {
                            EmptyView()
                        }
                    )
                    .hidden()
                )
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
                    .foregroundColor(.blue)
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
