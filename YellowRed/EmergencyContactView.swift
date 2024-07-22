//
//  EmergencyContactView.swift
//  YellowRed
//
//  Created by Krish Mehta on 17/6/23.
//

import SwiftUI
import FirebaseAuth

struct EmergencyContactView: View {
    @State private var emergencyContacts: [EmergencyContact] = Array(repeating: EmergencyContact(), count: 3)
    
    @State private var nextButtonClicked: Bool = false
    @State private var next: Bool = false
    
    @State private var sheet: Bool = true
    
    @ObservedObject private var validator = InputValidator()
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    let fullName: String
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? ""
    }
    
    let phoneNumber: String
    let emailAddress: String
    let affiliation: String
    let university: String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
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
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text("Emergency Contacts")
                            .font(.system(size: geometry.size.width * 0.08))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text("Please get started by choosing up to three emergency contacts. You will be able to change this later.")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 15) {
                            ForEach($emergencyContacts.indices, id: \.self) { index in
                                HStack {
                                    EmergencyContactPicker(contact: $emergencyContacts[index])
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: nextButtonClicked && (!validator.emergencyContactsSelected.contains(index) || validator.emergencyContactsDuplicated.contains(index)) ? 2.5 : 0)
                                        )
                                    
                                    Button(action: {
                                        if emergencyContacts.count > 1 {
                                            emergencyContacts.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                    .disabled(emergencyContacts.count <= 1)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if nextButtonClicked && (validator.emergencyContactsSelected.count < 1 || validator.emergencyContactsSelected.count > 3) {
                            Text("Please choose one to three emergency contacts!")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        if validator.emergencyContactsSelected.count >= 1 && validator.emergencyContactsSelected.count <= 3 && !validator.emergencyContactsDuplicated.isEmpty {
                            Text("Please choose one to three unique emergency contacts!")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        Button(action: {
                            if emergencyContacts.count < 3 {
                                emergencyContacts.append(EmergencyContact())
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        .disabled(emergencyContacts.count >= 3)
                        .opacity(emergencyContacts.count >= 3 ? 0 : 1)
                        
                        Spacer()
                        
                        Button(action: {
                            nextButtonClicked = true
                            validator.validateEmergencyContacts(emergencyContacts)
                            if validator.areEmergencyContactsValid {
                                if let userUID = Auth.auth().currentUser?.uid {
                                    userViewModel.updateEmergencyContacts(userId: userUID, emergencyContacts: emergencyContacts, completion: { result in
                                        switch result {
                                        case .success:
                                            next = true
                                        case .failure:
                                            print("Error adding emergency contacts")
                                        }
                                    })
                                }
                            }
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
                        .background(
                            NavigationLink(
                                destination: YellowMessageView().environmentObject(userViewModel),
                                isActive: $next,
                                label: { EmptyView() }
                            )
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .sheet(isPresented: $sheet){
                    EmergencyContactNoteView(sheet: $sheet)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EmergencyContactNoteView: View {
    @Environment (\.dismiss) var dismiss
    
    @Binding var sheet: Bool
    
    var body: some View{
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.yellow, .red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("YellowRed allows you to communicate with up to three emergency contacts.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 25)
                    
                    Text("These should be close friends and family that you can trust will help when you need it most.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 25)
                    
                    Button {
                        sheet = false
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75, height: 50)
                            .foregroundColor(.blue)
                            .overlay(
                                Text("OK")
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

struct EmergencyContactView_Previews: PreviewProvider {
    @State static var fullName: String = "John Smith"
    @State static var phoneNumber: String = "(123) 456-7890"
    @State static var emailAddress: String = "abc5xy@virginia.edu"
    @State static var affiliation: String = "Other"
    @State static var university: String = "Harvard University"
    
    static var previews: some View {
        EmergencyContactView(fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university).environmentObject(UserViewModel())
    }
}
