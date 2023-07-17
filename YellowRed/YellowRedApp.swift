//
//  YellowRedApp.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YellowRedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var fullName: String = "John Smith"
    @State var phoneNumber: String = "(123) 456-7890"
    @State var emailAddress: String = "abc5xy@virginia.edu"
    @State var affiliation: String = "Other"
    @State var university: String = "University of Michigan"
    @State var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(isSelected: true, displayName: "John Doe", phoneNumber: "+1 (234) 567-8901"),
        EmergencyContact(isSelected: true, displayName: "Jane Doe", phoneNumber: "+1 (234) 567-8902"),
        EmergencyContact(isSelected: true, displayName: "Baby Doe", phoneNumber: "+1 (234) 567-8903")
    ]
    @State var yellowMessage: String = "I'm feeling a bit uncomfortable, can we talk"
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
        }
    }
}
