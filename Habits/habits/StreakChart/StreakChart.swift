//
//  StreakChart.swift
//  Habits
//
//  Created by Marcel Jäger on 03.10.24.
//

import Foundation
import SwiftUI
import Charts


struct StreakChart: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: setPreviousMonth) {
                    Image(systemName: "arrowshape.left")
                }
                
                Spacer()
                
                Text("\(presentedMonth.nameOfMonth) \(presentedMonth.nameOfYear)")
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: setNextMonth) {
                    Image(systemName: "arrowshape.right")
                }
            }
            .buttonStyle(.borderless)
            
            Chart {
                ForEach(items) { item in
                    StreakMark(item: item)
                }
            }
            .chartYScale(domain: -1...6)
            .chartXScale(domain: StreakChart.xDomain)
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(position: AxisMarkPosition.top) {
                    AxisValueLabel(centered: true)
                }
            }
        }
        .frame(minWidth: 200, idealWidth: 200, minHeight: 275, idealHeight: 275)
        .onChange(of: presentedMonth,updateItems)
        .onChange(of: entries, updateItems)
    }
    
    let entries: Array<HabitEntry>
    
    @State private var items: Array<StreakChartItem>
    @State private var presentedMonth: StreakChartMonthComponent
    
    init(
        initialPresentedMonth: StreakChartMonthComponent = .current,
        entries: Array<HabitEntry>
    ) {
        self.presentedMonth = initialPresentedMonth
        self.items = StreakChart.createChartItems(by: initialPresentedMonth, of: entries)
        self.entries = entries
    }
    
    private func setPreviousMonth() {
        self.presentedMonth = presentedMonth.previousMonth
    }
    
    private func setNextMonth() {
        self.presentedMonth = presentedMonth.nextMonth
    }
    
    private func updateItems() {
        items = StreakChart.createChartItems(by: presentedMonth, of: entries)
    }
    
    static private func createChartItems(by month: StreakChartMonthComponent, of entries: Array<HabitEntry>) -> Array<StreakChartItem> {
        let daysOfHabitEntries: Set<StreakChartMonthComponent.Day> = Set(
            entries
                .map { StreakChartMonthComponent.Day(of: $0.date) }
                .filter { $0.monthValue == month.monthValue && $0.yearValue == month.yearValue }
        )
        let dayOfToday = StreakChartMonthComponent.Day(of: .now)
        
        return month.days.map { day in
            let status: StreakChartItem.Status = if daysOfHabitEntries.contains(day) {
                .isStreak
            }else if day <= dayOfToday {
                .noStreak
            } else {
                .none
            }
            return StreakChartItem(of: day, status: status)
        }
    }
    
    //Returns a sorted Array with the correct sorting of weekdays by the Calendar`s firstWeekday value.
    //It exists, because I noticed, that the sortWeekdaySymbols Array begins with Sunday event the  firstWeekday is Monday.
    static private var xDomain: Array<String> {
        let firstWeekdayKey = Calendar.current.firstWeekday
        let weekdays = StreakChart.shortWeekdayNames
        
        var sortedWeekdays: Array<String> = []
        var bufferForWeekdayBeforeFirstWeekday: Array<String> = []
        for weekday in weekdays.sorted(using: KeyPathComparator(\.key)) {
            if (weekday.key < firstWeekdayKey && weekdays.contains { $0.key == firstWeekdayKey }) {
                bufferForWeekdayBeforeFirstWeekday.append(weekday.value)
            }else {
                sortedWeekdays.append(weekday.value)
            }
        }
        sortedWeekdays.append(contentsOf: bufferForWeekdayBeforeFirstWeekday)
        return sortedWeekdays
    }
    
    //Returns the weekday with their key and their short name.
    //1 = Sun
    //2 = Mon
    //3 ...
    static private var shortWeekdayNames: Dictionary<Int, String> {
        let weekdaySymbols = Calendar.current.shortWeekdaySymbols
  
        var weekdayDictionary: Dictionary<Int, String> = [:]
        for wd in 1...7 {
            weekdayDictionary[wd] = weekdaySymbols[wd-1]
        }
        
        return weekdayDictionary
    }
}


#Preview {
    StreakChart(entries: [])
}
