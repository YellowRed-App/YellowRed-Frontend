//
//  LocationView.swift
//  YellowRed
//
//  Created by Krish Mehta on 8/6/23.
//

import SwiftUI
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus:  CLAuthorizationStatus?
    
   override init() {
       super.init()
       locationManager.delegate = self
   }
    // TODO: figure out what type of location data we need and want based on app functionality
    // check over **
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {
           case .authorizedWhenInUse:  // Location services are available.
               authorizationStatus = .authorizedWhenInUse
               // **
               locationManager.startMonitoringSignificantLocationChanges()
               break
               
           case .restricted:  // Location services currently unavailable.
               // Pop-up / message asking that they allow Location Services
               authorizationStatus = .restricted
               break
               
           case .denied:
               // Pop-up / message asking that they allow Location Services
               authorizationStatus = .denied
               break
               
           case .notDetermined:        // Authorization not determined yet.
               authorizationStatus = .notDetermined
               // **
               manager.requestWhenInUseAuthorization()
               print("requesting")
               break
               
           default:
               break
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //code for location stuff
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //code for when location access fails
        print("error: \(error.localizedDescription)")
    }
    
}

struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationDataManager = LocationDataManager()
    
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

                Image(systemName: "location.fill.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .padding()
                Text("Location Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                Text("Set your location to let YellowRed [insert friendly stuff here]")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 100)
                
                
                
                VStack {
                    Button(action: {
                        locationDataManager.locationManagerDidChangeAuthorization(locationDataManager.locationManager)
                    }) {
                        Text("ALLOW")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 300 )
// We should place a gradient on all buttons for a better look!
                            .background(.yellow)
                            .cornerRadius(50)
                    }
                    .padding(.bottom, 50)
                    
                    
                }
                
                Spacer()
            }
        }
    }
}

struct LocationView_Preview: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
