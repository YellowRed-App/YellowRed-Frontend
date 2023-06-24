//
//  GetStartedAffiliationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 30/5/23.
//

import SwiftUI

struct GetStartedAffiliationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var affiliation: String = ""
    @State private var isAffiliationValid = true
    
    @State private var university: String = ""
    
    @State private var next = false
    
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
                Text("Hello, \(firstName)...")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.top, 20)
                
                Text("What Is Your Affiliation With UVA?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    RadioButton(
                        id: "uva",
                        label: "UVA Student / Faculty",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    RadioButton(
                        id: "other",
                        label: "Other University",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal)
                    
                    if affiliation == "other" {
                        TextField("University Name", text: $university)
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .padding(.horizontal)
                    }
                    
                    RadioButton(
                        id: "none",
                        label: "Not Affiliated",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(.white.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
                if !isAffiliationValid {
                    Text("Please select an affiliation!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                Button(action: {
                    isAffiliationValid = validateAffiliation(affiliation)
                    next = isAffiliationValid
                }) {
                    HStack {
                        Text("Next")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
            }
            .padding(.horizontal)
            .cornerRadius(20)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .background(
                NavigationLink(
                    destination: NotificationsView(),
                    isActive: $next,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            )
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
    
    private func validateAffiliation(_ affiliation: String) -> Bool {
        if affiliation == "other" {
            return !university.isEmpty
        } else {
            return !affiliation.isEmpty
        }
    }
}

struct RadioButton: View {
    let id: String
    let label: String
    @Binding var isSelected: String
    @Binding var isAffiliationValid: Bool
    
    var body: some View {
        Button(action: {
            isSelected = id
            isAffiliationValid = true
        }) {
            HStack(alignment: .top) {
                Image(systemName: isSelected == id ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.black)
                Text(label)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .padding(12.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
        }
        .foregroundColor(.black)
    }
}

struct GetStartedAffiliationView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedAffiliationView(fullName: "John Smith")
    }
}
