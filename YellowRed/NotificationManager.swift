//
//  NotificationManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 9/7/23.
//

import UserNotifications

final class NotificationManager: NSObject, ObservableObject {
    @Published var next: Bool = false
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    self.next = true
                }
            } else {
                self.next = true
            }
        }
    }
}
