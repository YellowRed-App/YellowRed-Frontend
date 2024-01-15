//
//  NotificationManager.swift
//  YellowRed
//
//  Created by Krish Mehta on 9/7/23.
//

import UserNotifications

final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var next: Bool = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.next = granted
            }
        }
    }
    
    func scheduleNotification(button buttonState: String) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ \(buttonState.capitalized) Button Alert ⚠️"
        content.body = "The \(buttonState.capitalized) Button will be automatically deactivated in 15 minutes. To keep the \(buttonState.capitalized) Button activated, launch the app and click the extend button."
        content.sound = .default
        
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2700, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
