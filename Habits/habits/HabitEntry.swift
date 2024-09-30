//
//  HabitEntry.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import Foundation
import SwiftData

@Model class HabitEntry {
    var date: Date
    @Relationship(deleteRule: .nullify) var habit: Habit
    var created: Date
    
    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
        self.created = .now
    }
}
