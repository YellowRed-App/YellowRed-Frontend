//
//  ProfileView.swift
//  YellowRed
//
//  Created by William Shaoul on 7/1/23.
//  Edited by Krish Mehta on 4/7/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = "John Smith"
    @State private var phoneNumber: String = "(123) 456-7890"
    @State private var emailAddress: String = "abc5xy@virginia.edu"
    @State private var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(isSelected: false, displayName: "Contact 1", phoneNumber: "+1 (123) 456-7891"),
        EmergencyContact(isSelected: false, displayName: "Contact 2", phoneNumber: "+1 (123) 456-7892"),
        EmergencyContact(isSelected: false, displayName: "Contact 3", phoneNumber: "+1 (123) 456-7893")
    ]
    
    @State private var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    @State private var redMessage: String = "I'm feeling a bit unsafe, can you check on me"
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 128, height: 128)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text(fullName)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .frame(maxWidth: .infinity, minHeight: 250)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(25)
                        .edgesIgnoringSafeArea(.all)
                    )
                    
                    VStack {
                        SectionView(title: "Personal Info", content:  {
                            InfoView(title: "Phone Number", value: phoneNumber)
                            InfoView(title: "Email Address", value: emailAddress)
                        }, destinationView: AnyView(EditPersonalView()))
                        
                        SectionView(title: "Emergency Contacts", content:  {
                            ForEach(emergencyContacts.indices, id: \.self) { index in
                                InfoView(title: "Contact \(index + 1)", value: "\(emergencyContacts[index].displayName) (\(emergencyContacts[index].phoneNumber))")
                            }
                        }, destinationView: AnyView(EditEmergencyContactView()))
                        
                        SectionView(title: "Custom Messages", content:  {
                            InfoView(title: "Yellow\nButton", value: yellowMessage)
                            InfoView(title: "Red\nButton", value: redMessage)
                        }, destinationView: AnyView(EditCustomMessageView()))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct InfoView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct SectionView<Content: View>: View {
    var title: String
    var content: Content
    var destinationView: AnyView?
    
    init(title: String, @ViewBuilder content: () -> Content, destinationView: AnyView? = nil) {
        self.title = title
        self.content = content()
        self.destinationView = destinationView
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if let destinationView = destinationView {
                        NavigationLink(destination: destinationView) {
                            Label("Edit", systemImage: "square.and.pencil")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.bottom, 10)
                content
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(
                            colors: [.yellow, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 5
                    )
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct EditPersonalView: View {
    var body: some View {
        Text("Edit Personal View")
    }
}

struct EditEmergencyContactView: View {
    var body: some View {
        Text("Edit Emergency Contact View")
    }
}

struct EditCustomMessageView: View {
    var body: some View {
        Text("Edit Custom Message View")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
