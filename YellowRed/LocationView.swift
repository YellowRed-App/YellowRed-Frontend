//
//  LocationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 8/6/23.
//

import SwiftUI
import CoreLocation

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    
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
                
                Image(systemName: "location.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Enable Location Services")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("YellowRed will keep you posted with location-based services.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("In order to receive alerts based on your geographic location, you must have your location sharing permissions set to \"Always\" with \"Precise Location\" enabled.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    locationManager.requestLocationPermission()
                }) {
                    Text("Enable Location")
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
                        destination: EmergencyContactView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university),
                        isActive: $locationManager.next,
                        label: { EmptyView() }
                    )
                )
                .alert(isPresented: $locationManager.alert) {
                    Alert(
                        title: Text("Location Services Disabled"),
                        message: Text("Please enable Location Services in Settings."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LocationView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    @State static var affiliation: String = "Other"
    @State static var university: String = "University of Michigan"
    
    static var previews: some View {
        LocationView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university)
    }
}
