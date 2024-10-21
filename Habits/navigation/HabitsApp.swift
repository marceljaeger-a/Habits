//
//  HabitsApp.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import SwiftUI
import SwiftData

@main
struct HabitsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
        }
        .modelContainer(for: Habit.self, inMemory: false)
    }
}
