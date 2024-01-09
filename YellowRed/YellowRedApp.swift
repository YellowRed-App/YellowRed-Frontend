//
//  YellowRedApp.swift
//  YellowRed
//
//  Created by Krish Mehta on 26/5/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let handled = Auth.auth().canHandleNotification(userInfo)
        if handled {
            completionHandler(.noData)
        }
    }
}

@main
struct YellowRedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userAuth = UserAuth()
    
    var body: some Scene {
        WindowGroup {
            if userAuth.isUserAuthenticated {
                YellowRedView()
            } else {
                HomeScreenView()
            }
        }
    }
}
