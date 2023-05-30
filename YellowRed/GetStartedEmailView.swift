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
                
                Text("Enter Email")
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
                    .padding(.bottom, 25)
                
                NavigationLink(destination: GetStartedAffiliationView(fullName: fullName)) {
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
                .padding(.bottom, 25)
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
    
}

struct GetStartedEmailView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedEmailView(fullName: "John Smith")
    }
}
