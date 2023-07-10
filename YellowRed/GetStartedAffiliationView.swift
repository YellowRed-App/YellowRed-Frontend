//
//  GetStartedAffiliationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedAffiliationView: View {
    @State private var affiliation: String = ""
    @State private var isAffiliationValid: Bool = true
    @State private var isUniversityValid: Bool = true
    @State private var isValid: Bool = true
    @State private var university: String = ""
    
    @State private var next: Bool = false
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
    let phoneNumber: String
    let emailAddress: String
    
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
                
                Text("What Is Your Affiliation With UVA?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    RadioButton(
                        id: "UVA",
                        label: "UVA Student / Faculty",
                        isSelected: $affiliation
                    )
                    
                    RadioButton(
                        id: "Other",
                        label: "Other University",
                        isSelected: $affiliation
                    )
                    
                    if affiliation == "Other" {
                        ZStack(alignment: .leading) {
                            TextField("University Name", text: $university)
                            
                            if university.isEmpty {
                                Text("University Name")
                                    .opacity(0.5)
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isUniversityValid ? 0 : 2.5)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    RadioButton(
                        id: "None",
                        label: "Not Affiliated",
                        isSelected: $affiliation
                    )
                }
                .padding(.vertical, 20)
                .background(.white.opacity(0.25))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: isAffiliationValid ? 0 : 2.5)
                )
                .padding(.horizontal, 20)
                
                if !isAffiliationValid {
                    Text("Please select an affiliation!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if !isUniversityValid {
                    Text("Please enter a university!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    let validationResult = InputValidator.validateAffiliation(affiliation: affiliation, university: university)
                        isValid = validationResult.isValid
                        isAffiliationValid = validationResult.isAffiliationValid
                        isUniversityValid = validationResult.isUniversityValid
                    
                    if isValid {
                        next = true
                    }
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right.circle.fill")
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
                        destination: NotificationView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .endEditingOnTap()
    }
}

struct GetStartedAffiliationView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    
    static var previews: some View {
        GetStartedAffiliationView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress)
    }
}
