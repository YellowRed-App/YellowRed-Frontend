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
    @State private var isAffiliationValid: Bool = true
    
    @State private var university: String = ""
    
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
                
                Text("What Is Your Affiliation With UVA?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    RadioButton(
                        id: "uva",
                        label: "UVA Student / Faculty",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    RadioButton(
                        id: "other",
                        label: "Other University",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal, 20)
                    
                    if affiliation == "other" {
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
                        .padding(.horizontal, 20)
                    }
                    
                    RadioButton(
                        id: "none",
                        label: "Not Affiliated",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(.white.opacity(0.25))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                if !isAffiliationValid {
                    Text("Please select an affiliation!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    isAffiliationValid = InputValidator.validateAffiliation(affiliation, university)
                    next = isAffiliationValid
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
                .padding(.horizontal, 20)
                .background(
                    NavigationLink(
                        destination: NotificationsView(),
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
                Text(label)
            }
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .padding(12.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
        }
    }
}

struct GetStartedAffiliationView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedAffiliationView(fullName: "John Smith")
    }
}
