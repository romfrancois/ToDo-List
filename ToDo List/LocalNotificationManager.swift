//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Romain Francois on 04/07/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
    
    static func authoriseLocalNotifications(viewController: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            if granted {
                print("Notifications authorisation granted")
            } else {
                print("Notifications authorisation denied by user!")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                }
            }
        }
    }
    
    static func isAuthorised(completed: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                completed(false)
                return
            }
            
            if granted {
                print("Notifications authorisation granted")
                completed(true)
            } else {
                print("Notifications authorisation denied by user!")
                completed(false)
            }
        }
    }
    
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        // create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("\(error.localizedDescription) adding notification request went wrong")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        
        return notificationID
    }
}
