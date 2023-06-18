//
//  GetStartedEmailView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var isEmailValid = true
    @State private var verificationCode: String = ""
    @State private var isVerificationEnabled: Bool = false
    @State private var isVerified: Bool = false
    
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
                
                Text("Enter Organization Email")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                TextField("abc5xy@virginia.edu", text: $email)
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
                            .stroke(.black, lineWidth: isEmailValid ? 0 : 1)
                    )
                
                if !isEmailValid {
                    Text("Please enter a valid email address!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if isEmailValid && isVerificationEnabled && isVerified {
                    TextField("Verification Code", text: $verificationCode)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 300)
                        .background(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: GetStartedAffiliationView(fullName: fullName), isActive: $next) {
                    Button(action: {
                        isEmailValid = validateEmail(email)
                        if isEmailValid {
                            if isVerificationEnabled {
                                next = true
                            } else {
                                sendVerificationCode()
                                isVerificationEnabled = true
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
                            .padding(.bottom, 25)
                    }
                }
                .padding(.vertical, 25)
            }
            .padding()
            .cornerRadius(20)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
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
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func sendVerificationCode() {
        // TODO: verification algorithm
        isVerified = true
    }
}

struct GetStartedEmailView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedEmailView(fullName: "John Smith")
    }
}
