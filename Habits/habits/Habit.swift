//
//  Habit.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import Foundation
import SwiftData

@Model final class Habit {
    var title: String
    var notes: String
    var dailyTime: Date
    var symbole: String
    @Relationship var entries: Array<HabitEntry>
    var created: Date
    
    
    init(title: String, notes: String, dailyTime: Date, symbole: String, entries: Array<HabitEntry> = []) {
        self.title = title
        self.notes = notes
        self.dailyTime = dailyTime
        self.symbole = symbole
        self.entries = entries
        self.created = .now
    }
}
