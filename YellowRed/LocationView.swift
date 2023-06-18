//
//  LocationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 8/6/23.
//

import SwiftUI
import CoreLocation

struct LocationView: View {
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
            
            VStack {
                Spacer()
                
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .padding()
                
                Text("Enable Location Services")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("YellowRed will keep you posted with location-based services.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("In order to receive alerts based on your geographic location, you must have your location sharing permissions set to \"Always\" with \"Precise Location\" enabled.")
                    .font(.subheadline)
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
                destination: WelcomeView(),
                isActive: $next,
                label: { EmptyView() }
            )
        )
    }
    
    private func handleYesButtonTap() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            DispatchQueue.main.async {
                next = true
            }
        } else {
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func handleNoButtonTap() {
        next = true
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}