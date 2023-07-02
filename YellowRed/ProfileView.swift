//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 7/1/23.
//

import SwiftUI

struct ProfileView: View {
    
    var selectedYellow: String = "Example Yellow"
    var selectedRed: String = "Example Red"
    
    let fullName: String = "John Smith"
    let email: String = "abc5xy@virginia.edu"
    let number: String = "(123) 456-7890"
    
    let emergencyContacts = ["John Doe 123-456", "Jane Smith 444-555", "Sam Johnson 789-101"]
    
    let gradient = Gradient(colors: [.yellow, .red])
    
    var body: some View {
            NavigationStack{
                VStack{
                    HStack{
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 83.5))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .padding(.trailing, 120)
                        
                        Text(fullName)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 45))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(
                        LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .frame(width: 350, height: 145)
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
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("Email: \(email)")
                                .multilineTextAlignment(.leading)
                            Text("Phone: \(number)")
                                .multilineTextAlignment(.leading)
                            
                            NavigationLink(destination: EditProfileView()) {
                                Label("Edit Profile", systemImage: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(width: 300, alignment: .leading)
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
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Emergency Contacts")
                                .font(.title)
                                .fontWeight(.semibold)
                            //                            .italic()
                            ForEach(emergencyContacts, id: \.self) { contact in
                                Text(contact)
                            }
                            
                            NavigationLink(destination: EditContactsView()) {
                                Label("Edit Emergency Contacts", systemImage: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(width: 300, alignment: .leading)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .frame(width: 350, height: 200)
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
                        VStack(alignment: .leading) {
                            Text("Messages")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1)
                            
                            Text("Yellow")
                                .font(.system(size: 23))
                                .fontWeight(.semibold)
                            Text(selectedYellow)
                                .padding(.bottom, 1)
                                
                            Text("Red")
                                .font(.system(size: 23))
                                .fontWeight(.semibold)
                            Text(selectedRed)
                                .padding(.bottom, 1)
                            
                            NavigationLink(destination: EditContactsView()) {
                                Label("Edit Messages", systemImage: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(width: 300, alignment: .leading)
                        
                    }
                }
                .frame(maxHeight: .infinity,alignment: .top)
            }
        }
    }

struct EditProfileView : View {
    var body: some View{
        Text("Edit Profile View")
    }
    
}

struct EditContactsView : View {
    var body: some View{
        Text("Edit Contacts View")
    }
    
}

struct EditMessagesView : View {
    var body : some View{
        Text("Edit Messages")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
