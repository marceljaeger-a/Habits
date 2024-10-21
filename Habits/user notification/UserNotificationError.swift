//
//  UserNotificationError.swift
//  Habits
//
//  Created by Marcel Jäger on 21.10.24.
//

import Foundation

enum UserNotificationError: Error {
    case invalidAuthorizationRequest
    case failedAddingNotificatin
}
