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
    
    @State private var next: Bool = false
    
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
                    .padding(.horizontal)
                
                Text("In order to receive alerts based on your geographic location, you must have your location sharing permissions set to \"Always\" with \"Precise Location\" enabled.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
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
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarBackButtonHidden(true)
        }
        .background(
            NavigationLink(
                destination: EmergencyView(),
                isActive: $next,
                label: { EmptyView() }
            )
        )
    }
    
    private func handleYesButtonTap() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            next = true
        } else {
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            DispatchQueue.main.async {
                 next = true
            }
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
