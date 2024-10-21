//
//  HabitDetailView.swift
//  Habits
//
//  Created by Marcel Jäger on 10.10.24.
//

import Foundation
import SwiftUI

struct HabitDetailView: View {
    var body: some View {
        VStack {
            StreakChart(entries: habit.entries)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Label("\(habit.streak) days!", systemImage: "flame")
                    .foregroundStyle(.orange)
                    .font(.title3.bold())
                Spacer()
                
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(habit.title)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: presentDeleteHabitConfirmationDialog) {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
            
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button(action: setStreakAction) {
                    Label("Streak", systemImage: "flame")
                }
                .disabled(habit.hasEntryToday)
            }
            
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button(action: editHabitAction) {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .confirmationDialog("Delete habit", isPresented: $isDeleteConfirmationDialogPresented) {
            Button(role: .destructive, action: deleteAction) {
                Text("Delete")
            }
        } message: {
            Text("Do you really want to delete the habit, you can`t undo it?")
        }
    }
    
    let habit: Habit
    
    @Environment(NavigationManager.self) private var navManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.noticifationService) private var notificationService
    @State private var isDeleteConfirmationDialogPresented = false
    
    private func presentDeleteHabitConfirmationDialog() {
        isDeleteConfirmationDialogPresented.toggle()
    }
    
    private func setStreakAction() {
        let newEntry = HabitEntry(date: .now, habit: habit)
        habit.entries.append(newEntry)
        
        UserNotificationFunctions.addNotificationOfHabitForTommorow(habit, notificationService: notificationService)
    }
    
    private func editHabitAction() {
        navManager.path.append(EditHabitDestinationItem(habit: habit))
    }
    
    private func deleteAction() {
        UserNotificationFunctions.removeNotificationsOfHabit(habit, notificationService: notificationService)
        
        modelContext.delete(habit)
        navManager.path.removeLast()
    }
}
