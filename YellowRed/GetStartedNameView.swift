//
//  GetStartedNameView.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI

struct GetStartedNameView: View {
    @State private var fullName: String = ""
    @State private var next: Bool = false
    
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
                        .padding(.bottom, 25)
                    
                    Button(action: {
                        next = true
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
                    .fullScreenCover(isPresented: $next) {
                        GetStartedNumberView(fullName: fullName)
                    }
                }
                .padding()
                .cornerRadius(20)
            }
        }
    }
}

struct GetStartedNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedNameView()
    }
}
