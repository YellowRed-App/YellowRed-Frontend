//
//  NotificationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 5/6/23.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    @StateObject private var notificationManager = NotificationManager()
    
    let fullName: String
    let phoneNumber: String
    let emailAddress: String
    let affiliation: String
    let university: String
    
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Get Instant Updates")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("YellowRed will keep you posted with push notifications.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    notificationManager.requestNotificationPermission()
                }) {
                    Text("Enable Notifications")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(12.5)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .background(
                    NavigationLink(
                        destination: LocationView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university),
                        isActive: $notificationManager.next,
                        label: { EmptyView() }
                    )
                )
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct NotificationView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    @State static var affiliation: String = "Other"
    @State static var university: String = "University of Michigan"
    
    static var previews: some View {
        NotificationView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university)
    }
}
