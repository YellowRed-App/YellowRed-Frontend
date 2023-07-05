//
//  EmergencyContactView.swift
//  YellowRed
//
//  Created by Krish Mehta on 17/6/23.
//

import SwiftUI

struct EmergencyContactView: View {
    @State private var emergencyContacts: [EmergencyContact] = Array(repeating: EmergencyContact(), count: 3)
    @State private var areEmergencyContactsValid: Bool = true
    
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
                
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Emergency Contacts")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Text("Please get started by choosing three emergency contacts. You will be able to change this later.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        EmergencyContactPicker(contact: $emergencyContacts[index])
                    }
                }
                .padding(.horizontal, 20)
                
                if !areEmergencyContactsValid {
                    Text("Please choose three unique emergency contacts!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    areEmergencyContactsValid = InputValidator.validateEmergencyContacts(emergencyContacts)
                    next = areEmergencyContactsValid
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(12.5)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 20)
                .background(
                    NavigationLink(
                        destination: YellowMessageView(),
                        isActive: $next,
                        label: { EmptyView() }
                    )
                )
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EmergencyContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactView()
    }
}
