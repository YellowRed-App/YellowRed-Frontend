//
//  NotificationsView.swift
//  YellowRed
//
//  Created by Krish Mehta on 5/6/23.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var next = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Spacer()
                
                Image(systemName: "iphone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .padding()
                Text("Get Instant Updates")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("YellowRed will keep you posted with push notifications.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack {
                    Button(action: {
                        handleYesButtonTap()
                    }) {
                        Text("Yes")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 100)
                            .background(.yellow)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    
                    Button(action: {
                        handleNoButtonTap()
                    }) {
                        Text("No")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(10)
                            .frame(width: 100)
                            .background(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(20)
                .navigationBarBackButtonHidden(true)
            }
            .ignoresSafeArea()
        }
        .background(
            NavigationLink(
                destination: LocationView(),
                isActive: $next,
                label: { EmptyView() }
            )
        )
    }
    
    private func handleYesButtonTap() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    next = true
                }
            } else {
                next = true
            }
        }
    }
    
    private func handleNoButtonTap() {
        next = true
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
