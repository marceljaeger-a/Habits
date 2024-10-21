//
//  UserNotificationService.swift
//  Habits
//
//  Created by Marcel Jäger on 14.10.24.
//

import Foundation
@preconcurrency import UserNotifications

struct UserNotificationService: Sendable {
    private var center: UNUserNotificationCenter {
        .current()
    }
    
    init() {
        
    }
    
    func fetchSettings() async -> UNNotificationSettings {
        let settings = await center.notificationSettings()
        print("Fetched settings for User Notifications")
        return settings
    }
    
    func fetchAuthorization() async -> UNAuthorizationStatus {
        let status = await fetchSettings().authorizationStatus
        print("Fetched authorization for User Notificiations")
        return status
    }
    
    func hasAuthorization() async -> Bool {
        await fetchAuthorization() == .authorized
    }
    
    func requestAuthorization(with options: UNAuthorizationOptions = [.alert]) async throws(UserNotificationError) {
        do {
            try await center.requestAuthorization(options: options)
            print("Requested authorization for User Notificiations")
        } catch {
            print(error)
            throw .invalidAuthorizationRequest
        }
    }
    
    @MainActor
    func addNotification(_ notification: UserNotification) async throws(UserNotificationError) {
        do {
            try await center.add(notification.getUNNotificationRequest())
            print("Added notification \(notification)")
        } catch {
            throw .failedAddingNotificatin
        }
    }
    
    func removePendingNotifications(with identifiers: UserNotificationIdentifier...) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers.map { $0.description })
        for identifier in identifiers {
            print("Deleted pending notification with \(identifier)")
        }
    }
    
    func removeDeliveredNotifications(with identifiers: UserNotificationIdentifier...) {
        center.removeDeliveredNotifications(withIdentifiers: identifiers.map { $0.description })
        for identifier in identifiers {
            print("Deleted delivered notification with \(identifier)")
        }
    }
    
    func removeAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
        print("Deleted all pending notifications")
    }
    
    func removeAllDeliveredNotifications() {
        center.removeAllDeliveredNotifications()
        print("Deleted all delvicered notifications")
    }
}
