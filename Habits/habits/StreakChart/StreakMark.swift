//
//  StreakMark.swift
//  Habits
//
//  Created by Marcel Jäger on 10.10.24.
//

import Foundation
import Charts
import SwiftUI

struct StreakMark: ChartContent {
    var body: some ChartContent {
        PointMark(x: .value("Weekday", item.xValue), y: .value("Week", item.yValue))
            .symbol {
                Image(systemName: item.systemName)
                    .foregroundStyle(item.color)
                    .font(item.font)
            }
    }
    
    let item: StreakChartItem
}


struct StreakChartItem: Identifiable, Hashable {
    enum Status {
        case isStreak
        case noStreak
        case none
    }
    
    let id: UUID
    
    //Week
    let yValue: Int
    
    //Day
    let xValue: String
    let status: Status
    let day: StreakChartMonthComponent.Day
    
    init(of day: StreakChartMonthComponent.Day, status: Status) {
        self.id = .init()
        self.yValue = Self.yValue(of: day)
        self.xValue = Self.xValue(of: day)
        self.status = status
        self.day = day
    }
    
    var systemName: String {
        switch status {
        case .isStreak:
            "flame.fill"
        case .noStreak:
            "circle.fill"
        case .none:
            "circle.fill"
        }
    }
    
    var font: Font {
        switch status {
        case .isStreak:
            .title
        case .noStreak:
            .title2
        case .none:
            .body
        }
    }
    
    var color: Color {
        switch status {
        case .isStreak:
                .orange
        case .noStreak:
                .secondary
        case .none:
                .secondary
        }
    }
    
    //It inverts the items' week value. So if the value is 5 as instance, it will be inverted to 0.
    //It exists because the Chart shows the lowest value on the bottom automatically, but I wil show the first week on the top.
    static func yValue(of day: StreakChartMonthComponent.Day) -> Int {
        switch day.weekValue {
        case 0:
            5
        case 1:
            4
        case 2:
            3
        case 3:
            2
        case 4:
            1
        case 5:
            0
        default:
            0
        }
    }
    
    static func xValue(of day: StreakChartMonthComponent.Day) -> String {
        let weekdaySymbols = Calendar.current.shortWeekdaySymbols
        return weekdaySymbols[day.weekdayValue-1]
    }
}
