//
//  HabitsListView.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import Foundation
import SwiftUI
import SwiftData

struct HabitsListView: View {
    var body: some View {
        List {
            Section {
                ForEach(todayHabits) { todayHabit in
                    HabitListRowView(habit: todayHabit)
                }
            } header: {
                Text("Today")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            Section {
                ForEach(otherHabits) { habit in
                    HabitListRowView(habit: habit)
                }
            } header: {
                Text("Other")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
        }
        .navigationTitle("Habits")
        .navigationBarTitleDisplayMode(.large)
    }
    
    //MARK: - View Model
    
    @Query(filter: Habit.hasEntryTodayPredicate, sort: [SortDescriptor(\Habit.hour, order: .reverse), SortDescriptor(\Habit.minute, order: .reverse), SortDescriptor(\Habit.second, order: .reverse)]) var otherHabits: Array<Habit>
    @Query(filter: Habit.hasNoEntryTodayPredicate, sort: [SortDescriptor(\Habit.hour, order: .reverse), SortDescriptor(\Habit.minute, order: .reverse), SortDescriptor(\Habit.second, order: .reverse)]) var todayHabits: Array<Habit>
}