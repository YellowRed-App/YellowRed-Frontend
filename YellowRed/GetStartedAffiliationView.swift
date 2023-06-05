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
            
            VStack {
                Text("Hello, \(firstName)...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
                
                Text("What Is Your Affiliation With UVA?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 10) {
                    RadioButton(
                        id: "uva",
                        label: "UVA Student / Faculty",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    RadioButton(
                        id: "other",
                        label: "Other University",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                    RadioButton(
                        id: "none",
                        label: "Not Affiliated",
                        isSelected: $affiliation,
                        isAffiliationValid: $isAffiliationValid
                    )
                }
                
                if !isAffiliationValid {
                    Text("Please select an affiliation!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    isAffiliationValid = validateAffiliation(affiliation)
                    next = isAffiliationValid
                }) {
                    Text("Next")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width: 100)
                        .background(.yellow)
                        .cornerRadius(10)
                        .padding(.bottom, 25)
                }
                .padding(.vertical, 25)
            }
            .padding()
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
                    .foregroundColor(.blue)
                Text("Back")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func validateAffiliation(_ affiliation: String) -> Bool {
        return !affiliation.isEmpty
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.white)
            .cornerRadius(10)
        }
        .foregroundColor(.black)
    }
}

struct GetStartedAffiliationView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedAffiliationView(fullName: "John Smith")
    }
}
