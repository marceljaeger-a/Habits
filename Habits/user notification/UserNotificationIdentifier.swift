//
//  UserNotificationIdentifier.swift
//  Habits
//
//  Created by Marcel Jäger on 21.10.24.
//

import Foundation
import UserNotifications

struct UserNotificationIdentifier: CustomStringConvertible {
    //TODO: Edit this!
    var description: String
    
    init(notificationIdentifierOfHabit: String) {
        self.description = "user_notification_habit_\(notificationIdentifierOfHabit)"
    }
    
    init(_ id: String) {
        self.description = id
    }
}
