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
    var reward: String
    var hour: Int
    var minute: Int
    var second: Int
    var symbole: HabitSymbole
    @Relationship(deleteRule: .cascade, inverse: \HabitEntry.habit) var entries: Array<HabitEntry>
    var created: Date
    
    var time: Date? {
        Calendar.current.date(from: .init(hour: hour, minute: minute, second: second))
    }
    
    var streak: Int {
        //1. Get all dates of entries in a sorted array
        let dates = entries.map { $0.date }.sorted()
        
        //2. Set states for algorithm
        var firstDate: Date? = nil
        var latestDate: Date? = nil
        
        //3. Calculate firstDate of latest streak
        for date in dates {
            if let latestDate {
                if Calendar.current.isDate(latestDate.addingTimeInterval(60 * 60 * 24), inSameDayAs: date) == false {
                    firstDate = nil
                }
            }
            if firstDate == nil {
                firstDate = date
            }
            latestDate = date
        }
        
        //4. Check if there is current streak
        guard let firstDate else {
            return 0
        }
        
        //5. React to exceptions, for example, if there is only one entry.
        if dates.count == 1 {
            //6. Cehck if the one date is today
            if Calendar.current.isDate(firstDate, inSameDayAs: .now) {
                return 1
            }else {
                return 0
            }
        }
        
        //7. Check if there is a last data in the array and if it isn't equal to first date
        let lastDate = dates.last
        guard let lastDate, firstDate != lastDate else {
            return 1
        }
        
        //8. Calculate days between first and last date
        let startOfFirstDate = Calendar.current.startOfDay(for: firstDate)
        let startOfLastDate = Calendar.current.startOfDay(for: lastDate)
        let interval = DateInterval(start: startOfFirstDate, end: startOfLastDate)
        let days = interval.duration / 60 / 60 / 24
        return Int(days.rounded())
    }
    
    var hasEntryToday: Bool {
        entries.filter { Calendar.current.isDateInToday($0.date) }.count > 0
    }
    
    
    init(
        title: String,
        notes: String,
        reward: String,
        hour: Int,
        minute: Int = 0,
        second: Int = 0,
        symbole: HabitSymbole,
        entries: Array<HabitEntry> = []
    ) {
        self.title = title
        self.notes = notes
        self.reward = reward
        self.hour = hour
        self.minute = minute
        self.second = second
        self.symbole = symbole
        self.entries = entries
        self.created = .now
    }
}

extension Habit {
    static var todayEntriesCountExpression: Expression<[HabitEntry], Int> {
        let todayStartDate = Date.todayStartDate
        return #Expression<[HabitEntry], Int> { habitEntries in
            habitEntries.filter { $0.date > todayStartDate }.count
        }
    }
   
    static let hasNoEntryTodayPredicate = #Predicate<Habit> { habit in
        todayEntriesCountExpression.evaluate(habit.entries) == 0
    }
    
    static let hasEntryTodayPredicate = #Predicate<Habit> { habit in
        todayEntriesCountExpression.evaluate(habit.entries) != 0
    }
}

extension Date {
    static let todayStartDate = Calendar.current.startOfDay(for: Date.now)
}
