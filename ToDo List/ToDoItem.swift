//
//  ToDoItem.swift
//  ToDo List
//
//  Created by Romain Francois on 01/07/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
}
