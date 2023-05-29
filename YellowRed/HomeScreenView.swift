//
//  HomeScreenView.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var greeting: String = ""
    @State private var getStarted: Bool = false
    
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
                    
                    Text("Safety, One Click Away")
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
                            getStarted = true
                        }) {
                            Text("Get Started")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(width: 300)
                                .background(.yellow)
                                .cornerRadius(10)
                                .padding(.bottom, 25)
                        }
                        .fullScreenCover(isPresented: $getStarted) {
                            GetStartedNameView()
                        }
                        
//                        NavigationLink(
//                            destination: GetStartedNameView(),
//                            isActive: $getStarted,
//                            label: {
//                                Text("Get Started")
//                                    .font(.title)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.white)
//                                    .padding(10)
//                                    .frame(width: 300)
//                                    .background(.yellow)
//                                    .cornerRadius(10)
//                                    .padding(.bottom, 25)
//                            })
//                        .isDetailLink(false)
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
    }
    
    private func setGreeting() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        default:
            greeting = "Good Evening"
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
