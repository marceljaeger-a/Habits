//
//  HabitListRowView.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import Foundation
import SwiftUI
import SwiftData

struct HabitListRowView: View {
    var body: some View {
        NavigationLink(value: DetailHabitDestinationItem(habit: habit)) {
            HStack {
                habit.symbole.image.font(.title)
                
                Text(habit.title)
                    .font(.headline)
                
                Spacer()
                
                switch style {
                case .today:
                    ZStack(alignment: .centerFirstTextBaseline) {
                        Image(systemName: "flame")
                            .foregroundStyle(.gray)
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.gray)
                        Text("\(habit.streak)")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                    }
                    .imageScale(.large)
                    .font(.title)
                    .onTapGesture(perform: addHabitEntry)
                case .other:
                    ZStack(alignment: .centerFirstTextBaseline) {
                        Image(systemName: "flame")
                            .foregroundStyle(.orange)
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(habit.streak)")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                    }
                    .imageScale(.large)
                    .font(.title)
                }
            }
        }
        .swipeActions {
            NavigationLink(value: EditHabitDestinationItem(habit: habit)) {
                Image(systemName: "pencil")
            }
            .tint(.accentColor)
            
            Button(action: presentDeleteConfirmationDialog) {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading) {
            if style == .today {
                Button(action: addHabitEntry) {
                    Image(systemName: "flame")
                }
                .tint(.orange)
            }
        }
        .confirmationDialog("Delete habit", isPresented: $isDeleteConfirmationDialogPresented) {
            Button(role: .destructive, action: deleteHabit) {
                Text("Delete")
            }
        } message: {
            Text("Do you really want to delete the habit, you can`t undo it?")
        }

    }
    
    //MARK: - View Model
    
    let habit: Habit
    
    @Environment(\.modelContext) private var modelContext
    @State private var isDeleteConfirmationDialogPresented = false
    
    private var style: Style {
        habit.hasEntryToday ? .other : .today
    }
    
    private func addHabitEntry() {
        print("Add new entry")
        let newEntry = HabitEntry(date: .now, habit: habit)
        habit.entries.append(newEntry)
    }
    
    private func presentDeleteConfirmationDialog() {
        isDeleteConfirmationDialogPresented.toggle()
    }
    
    private func deleteHabit() {
        print("Delete habit")
        modelContext.delete(habit)
    }
}

extension HabitListRowView {
    enum Style {
        case other
        case today
    }
}
