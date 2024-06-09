//
//  HomeScreenView.swift
//  YellowRed Watch App
//
//  Created by Krish Mehta on 6/9/24.
//

import SwiftUI

struct HomeScreenView: View {
    
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
                
                VStack(spacing: 10) {
                    Spacer()
                    
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                    
                    Text("YellowRed")
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                    
                    Text("Your Peace of Mind Companion")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                    
                    Button(action: {
                        next = true
                    }) {
                        HStack {
                            Text("Log In")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                    }
                    .fullScreenCover(isPresented: $next) {
                        // TODO: create next view
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
