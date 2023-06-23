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
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "bell.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                Text("Get Instant Updates")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                Text("YellowRed will keep you posted with push notifications.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        handleYesButtonTap()
                    }) {
                        Text("Yes")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    
                    Button(action: {
                        handleNoButtonTap()
                    }) {
                        Text("No")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(12.5)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all)
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

