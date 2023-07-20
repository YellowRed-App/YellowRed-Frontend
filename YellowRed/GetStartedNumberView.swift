//
//  GetStartedNumberView.swift
//  YellowRed
//
//  Created by Krish Mehta on 29/5/23.
//

import SwiftUI


final class GetStartedNumberViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isPhoneNumberValid: Bool = true
    
    @Published var verificationCode: String = ""
    @Published var verificationCodeSent: String = ""
    
    @Published var isVerificationEnabled: Bool = false
    @Published var isVerificationValid: Bool = true
}

struct GetStartedNumberView: View {
    @StateObject private var model = GetStartedNumberViewModel()
    
    @State private var next: Bool = false
    
    @ObservedObject var inputVerifier = InputVerifier()
    
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
                        TextField("(123) 456-7890", text: $model.phoneNumber)
                            .onReceive(model.phoneNumber.publisher.collect()) {
                                let number = String($0)
                                if let formattedNumber = PhoneNumberFormatter.format(phone: number) {
                                    self.model.phoneNumber = formattedNumber
                                }
                            }
                        //                            .keyboardType(.numberPad)
                        
                        if model.phoneNumber.isEmpty {
                            Text("(123) 456-7890")
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
                        .stroke(.black, lineWidth: model.isPhoneNumberValid ? 0 : 2.5)
                )
                .disabled(model.isVerificationEnabled)
                
                if !model.isPhoneNumberValid {
                    Text("Please enter a valid phone number!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if model.isVerificationEnabled {
                    ZStack(alignment: .leading) {
                        TextField("Verification Code", text: $model.verificationCode)
                        //                            .keyboardType(.numberPad)
                        
                        if model.verificationCode.isEmpty {
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
                            .stroke(.black, lineWidth: model.isVerificationValid ? 0 : 2.5)
                    )
                    
                    if !model.isVerificationValid {
                        Text("Invalid verification code. Please try again!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    model.isPhoneNumberValid = InputValidator.validatePhoneNumber(model.phoneNumber)
                    if model.isPhoneNumberValid {
                        if model.isVerificationEnabled && model.verificationCode == model.verificationCodeSent {
                            inputVerifier.stopCooldown()
                            model.isVerificationValid = true
                            next = true
                        } else if model.isVerificationEnabled {
                            model.isVerificationValid = false
                        } else {
                            model.isVerificationEnabled = true
                            model.verificationCodeSent = inputVerifier.sendVerificationCodeViaSMS(to: model.phoneNumber)
                        }
                    }
                }) {
                    HStack {
                        Text(model.isVerificationEnabled ? "Next" : "Verify")
                        Image(systemName: model.isVerificationEnabled ? "arrow.right.circle.fill" : "checkmark.circle.fill")
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
                        destination: GetStartedEmailView(fullName: fullName, phoneNumber: model.phoneNumber),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                
                VStack(spacing: 10) {
                    if model.isVerificationEnabled {
                        Button(action: {
                            if !inputVerifier.cooldown {
                                model.verificationCodeSent = inputVerifier.resendVerificationCodeViaSMS(to: model.phoneNumber)
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

struct GetStartedNumberView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    
    static var previews: some View {
        GetStartedNumberView(fullName: fullName)
    }
}
