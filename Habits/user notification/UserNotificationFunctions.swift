//
//  UserNotificationFunctions.swift
//  Habits
//
//  Created by Marcel Jäger on 21.10.24.
//

import Foundation
import UserNotifications

@MainActor
enum UserNotificationFunctions {
    static func habitReminderNotification(of habit: Habit) -> UserNotification? {
        guard let nextDateComponents = habit.dateComponentsOfTommorow else { return nil }
        return UserNotification(identifier: UserNotificationIdentifier(habit.notificationIdentifier), title: " \(habit.title)", body: "\(habit.streak)🔥", sound: .default, time: nextDateComponents)
    }
    
    static func addNotificationOfHabitForTommorow(_ habit: Habit, notificationService: UserNotificationService) {
        //Add notification
        if let notification = habitReminderNotification(of: habit) {
            Task {
                do {
                    //NotificationCenter overrides the notification automatically.
                    try await notificationService.addNotification(notification)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    static func removeNotificationsOfHabit(_ habit: Habit, notificationService: UserNotificationService) {
        let notificationIdentifier = UserNotificationIdentifier(notificationIdentifierOfHabit: habit.notificationIdentifier)
        notificationService.removePendingNotifications(with: notificationIdentifier)
        notificationService.removeDeliveredNotifications(with: notificationIdentifier)
    }
    
    static func cleanUp(notificationService: UserNotificationService) {
        notificationService.removeAllDeliveredNotifications()
    }
}
