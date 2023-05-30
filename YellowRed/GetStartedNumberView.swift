//
//  GetStartedNumberView.swift
//  YellowRed
//
//  Created by Krish Mehta on 29/5/23.
//

import SwiftUI

struct GetStartedNumberView: View {
    @State private var phoneNumber: String = ""
    @State private var next: Bool = false
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
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
                    Text("Hello, \(firstName)...")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                    
                    Text("Enter Phone Number")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    TextField("(123) 456-7890", text: $phoneNumber)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 300)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 25)
                    
                    Button(action: {
                        next = true
                    }) {
                        Text("Verify")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 100)
                            .background(.yellow)
                            .cornerRadius(10)
                            .padding(.bottom, 25)
                    }
                    .fullScreenCover(isPresented: $next) {
                        GetStartedEmailView()
                    }
                }
                .padding()
                .cornerRadius(20)
            }
        }
    }
}

struct GetStartedNumberView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNumberView(fullName: "John Smith")
    }
}
