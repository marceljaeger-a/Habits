//
//  StreakChartMonthComponent.swift
//  Habits
//
//  Created by Marcel Jäger on 10.10.24.
//

import Foundation
import SwiftUI

struct StreakChartMonthComponent: Hashable {
    struct Day: Hashable,  Comparable {
        static func == (lhs: Day, rhs: Day) -> Bool {
            lhs.dayValue == rhs.dayValue && lhs.monthValue == rhs.monthValue && lhs.yearValue == rhs.yearValue
        }
        
        static func < (lhs: Day, rhs: Day) -> Bool {
            if lhs.yearValue != rhs.yearValue {
                return lhs.yearValue < rhs.yearValue
            } else if lhs.monthValue != rhs.monthValue {
                return lhs.monthValue < rhs.monthValue
            } else {
                return lhs.dayValue < rhs.dayValue
            }
        }
        
        let dayValue: Int
        let weekdayValue: Int
        let weekValue: Int
        let monthValue: Int
        let yearValue: Int
        
        init(dayValue: Int, weekdayValue: Int, weekValue: Int, monthValue: Int, yearValue: Int) {
            self.dayValue = dayValue
            self.weekdayValue = weekdayValue
            self.weekValue = weekValue
            self.monthValue = monthValue
            self.yearValue = yearValue
        }
        
        init(of date: Date) {
            self.init(
                dayValue: Calendar.current.component(.day, from: date),
                weekdayValue: Calendar.current.component(.weekday, from: date),
                weekValue: Calendar.current.component(.weekOfMonth, from: date),
                monthValue: Calendar.current.component(.month, from: date),
                yearValue: Calendar.current.component(.year, from: date)
            )
        }
    }
    
    let monthValue: Int
    let yearValue: Int
    
    var nameOfMonth: String {
        Calendar.current.monthSymbols[monthValue-1]
    }
    
    var nameOfYear: String {
        "\(yearValue)"
    }
    
    var firstDayOfMonth: Date? {
        Calendar.current.date(from: .init(calendar: .current, timeZone: .current, year: yearValue, month: monthValue, day: 1))
    }
    
    var days: Array<Day> {
        var days: Array<Day> = []
        if let firstDayOfMonth {
            var nextDate: Date? = firstDayOfMonth
            while let unwrappedNextDate = nextDate {
                let nextDay = Day(
                    dayValue: Calendar.current.component(.day, from: unwrappedNextDate),
                    weekdayValue: Calendar.current.component(.weekday, from: unwrappedNextDate),
                    weekValue: Calendar.current.component(.weekOfMonth, from: unwrappedNextDate),
                    monthValue: Calendar.current.component(.month, from: unwrappedNextDate),
                    yearValue: Calendar.current.component(.year, from: unwrappedNextDate)
                )
                days.append(nextDay)
                
                //Checks, if the next date is in the same month
                if let nextDateOfDay = Calendar.current.date(bySetting: .day, value: nextDay.dayValue + 1, of: unwrappedNextDate) {
                    if Calendar.current.component(.month, from: nextDateOfDay) == nextDay.monthValue {
                        nextDate = nextDateOfDay
                        continue
                    }
                }
                nextDate = nil
            }
        }
        return days
    }
    
    var previousMonth: Self {
        if monthValue <= 1 {
            return .init(monthValue: 12, yearValue: yearValue - 1)
        }else {
            return .init(monthValue: monthValue - 1, yearValue: yearValue)
        }
    }
    
    var nextMonth: Self {
        if monthValue >= 12 {
            return .init(monthValue: 1, yearValue: yearValue + 1)
        }else {
            return .init(monthValue: monthValue + 1, yearValue: yearValue)
        }
    }
    
    nonisolated static var current: Self {
        let currentMonthValue = Calendar.current.component(.month, from: .now)
        let currentYearValue = Calendar.current.component(.year, from: .now)
        return .init(monthValue: currentMonthValue, yearValue: currentYearValue)
    }
}
