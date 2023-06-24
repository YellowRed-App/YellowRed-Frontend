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
                
                VStack(spacing: 20) {
                    Text("Get Started")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    Text("Enter Full Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    TextField("John Smith", text: $fullName)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: isFullNameValid ? 0 : 1)
                        )
                        .padding(.horizontal, 20)
                    
                    if !isFullNameValid {
                        Text("Please enter a valid name!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    
                    Button(action: {
                        isFullNameValid = validateFullName(fullName)
                        next = isFullNameValid
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
                .padding(.horizontal)
            }
        }
    }
    
    private func validateFullName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z\\.\\'\\-]{2,50}(?: [a-zA-Z\\.\\'\\-]{2,50})+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
}

struct GetStartedNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNameView()
    }
}
