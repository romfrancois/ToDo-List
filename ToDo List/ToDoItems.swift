//
//  ToDoItems.swift
//  ToDo List
//
//  Created by Romain Francois on 04/07/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import Foundation
import UserNotifications

class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

        guard let data = try? Data(contentsOf: documentURL) else { return }

        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
//            tableView.reloadData()
        } catch {
            print("Error while saving data! \(error.localizedDescription)")
        }
        
        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Error while saving data! \(error.localizedDescription)")
        }
        
        setNotification()
    }
    
    func setNotification() {
        guard itemsArray.count > 0 else {
            return
        }
        
        // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and lets re-create then with the updated data that we just saved
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
}
