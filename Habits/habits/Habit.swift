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
    var notificationIdentifier: String = UUID().uuidString
    
    //Returns no explicit day!
    var time: Date? {
        Calendar.current.date(from: .init(hour: hour, minute: minute, second: second))
    }
    
    var dateComponents: DateComponents {
        DateComponents(hour: hour, minute: minute, second: second)
    }
    
    var dateComponentsOfTommorow: DateComponents? {
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        
        guard let tommorow else {
            return nil
        }
        
        let monthAndDayOfToday = Calendar.current.dateComponents([.month, .day, .year], from: tommorow)
        
        var components = self.dateComponents
        components.month = monthAndDayOfToday.month
        components.day = monthAndDayOfToday.day
        components.year = monthAndDayOfToday.year
        return components
    }
    
    var streak: Int {
        var count = 0
        
        //1. Alle entries sortiert in Dates umwandeln
        let allEntryDates = entries.map { $0.date }.sorted()
        
        //2. latestDate Variable erstellen.
        var latestIteratedDate: Date? = nil
        
        //3. Iteriere über alle Dates
        for date in allEntryDates {
            
            //3.1. Wenn latestDate != nil UND wenn latestDate + 1 Tag nicht in selben Tag wie iterierter Tag ist | -> Zähler zurücksetzen
            if let latestIteratedDate {
                if let nextDateOfLatestDate = Calendar.current.date(byAdding: .day, value: 1, to: latestIteratedDate) {
                    if Calendar.current.isDate(nextDateOfLatestDate, inSameDayAs: date) == false {
                        count = 0
                    }
                }else {
                    //COUNT ZURÜCKSETZEN ???
                }
            }
            
            //3.2. Zähler um eins erhöhen und latestDate setzen.
            count += 1
            latestIteratedDate = date
            
        }
        //4. Zähler zurückgeben
        return count
    }
    
    func streakedEntries() -> Array<HabitEntry> {
        var streakedEntries: Array<HabitEntry> = []
        
        //1. Alle entries sortiert nach Date
        let allEntrySortedByDates = entries.sorted(using: KeyPathComparator(\.date))
        
        //2. latestDate Variable erstellen
        var latestIteratedDate: Date? = nil
        
        //3. Iteriere über alle entries
        for entry in entries {
            
            if let latestIteratedDate {
                if let nextDateOfLatestDate = Calendar.current.date(byAdding: .day, value: 1, to: latestIteratedDate) {
                    if Calendar.current.isDate(nextDateOfLatestDate, inSameDayAs: entry.date) == false {
                        streakedEntries = []
                    }
                }else {
                    //???
                }
            }
            
            streakedEntries.append(entry)
            latestIteratedDate = entry.date
        }
        
        return streakedEntries
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
