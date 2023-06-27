//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 6/22/23.
//

import SwiftUI

struct ProfileView: View {
 
    let fullName: String
    let email: String
    let number: String
    
    
    let emergencyContacts = ["John Doe 123-456", "Jane Smith 444-555", "Sam Johnson 789-101"]
    
    var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 75))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.yellow, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                            )
                            .padding(.trailing, 120)

                        Text(fullName)
                            .font(.largeTitle)
                    }
                    .padding(.top, 20)

                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: 350, height: 120)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .red],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                )

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Personal Info")
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                Text("Email: \(email)")
                                    .multilineTextAlignment(.leading)
                                Text("Phone: \(number)")
                                    .multilineTextAlignment(.leading)
                            }
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: 350, height: 170)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .red],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 5
                                        )
                                )

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Emergency Contacts")
                                    .font(.title3)
                                    .bold()

                                ForEach(emergencyContacts, id: \.self) { contact in
                                    Text(contact)
                                }
                            }
                        }
                    }
                    .padding()

                    Spacer()

                    NavigationLink(destination: EditProfileView()) {
                        Label("Edit Profile", systemImage: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)

                    NavigationLink(destination: EditContactsView()) {
                        Label("Edit Emergency Contacts", systemImage: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .navigationBarTitle("Account", displayMode: .inline)
            }
        }
    }



struct EditProfileView : View {
    var body: some View{
        let _: String
    }
    
}

struct EditContactsView : View {
    var body: some View{
        let _: String
    }
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(fullName: "John Smith", email: "abc@xyz.com", number: "123-456-7890")
    }
}
