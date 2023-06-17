//
//  GetStartedNameView.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI

struct GetStartedNameView: View {
    @State private var fullName: String = ""
    @State private var isFullNameValid = true
    
    @State private var next = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.yellow, .red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Get Started")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                    
                    Text("Enter Full Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    TextField("John Smith", text: $fullName)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 300)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isFullNameValid ? 0 : 1)
                        )
                    
                    if !isFullNameValid {
                        Text("Please enter a valid name!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        isFullNameValid = validateFullName(fullName)
                        next = isFullNameValid
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
                    .background(
                        NavigationLink(
                            destination: GetStartedNumberView(fullName: fullName),
                            isActive: $next,
                            label: {
                                EmptyView()
                            }
                        )
                        .hidden()
                    )
                }
                .padding()
                .cornerRadius(20)
            }
        }
    }
    
    private func validateFullName(_ name: String) -> Bool {
        let nameRegex = "^[A-Za-z]+(?:\\s[A-Za-z]+)*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
}

struct GetStartedNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNameView()
    }
}
