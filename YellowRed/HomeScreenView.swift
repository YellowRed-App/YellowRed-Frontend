//
//  HomeScreenView.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var greeting: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow, Color.red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    // placeholder for logo
                    Image(systemName: "circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text("YellowRed")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding()
                
                Text("Our Sick Motto!!!!!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            
                Spacer()
                
                VStack {
                    Text(greeting)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        // action for button tap
                    }) {
                        Text("Get Started")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 300)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .cornerRadius(10)
                            .padding(.bottom, 25)
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            setGreeting()
        }
    }
    
    private func setGreeting() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<21:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
