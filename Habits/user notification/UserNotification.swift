//
//  UserNotification.swift
//  Habits
//
//  Created by Marcel Jäger on 21.10.24.
//

import Foundation
import UserNotifications

struct UserNotification: CustomStringConvertible {
    let identifier: UserNotificationIdentifier
    let title: String
    let body: String
    let sound: UNNotificationSound
    let time: DateComponents
    
    var unContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        return content
    }
    
    var description: String {
        "UserNotification(identifier: \(identifier), title: \(title), body: \(body), sound: \(sound), time: \(time))"
    }
    
    func getUNNotificationRequest(repeats: Bool = false) -> UNNotificationRequest {
        //Think about the repeats argument. I don`t know if I should use it, because when I cancel a notification, will it cancel all notification or only the next notificatin?
        let timeTrigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: repeats)
        return UNNotificationRequest(identifier: identifier.description, content: unContent, trigger: timeTrigger)
    }
}
