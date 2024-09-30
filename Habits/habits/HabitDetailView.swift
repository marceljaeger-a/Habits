//
//  HabitDetailView.swift
//  Habits
//
//  Created by Marcel Jäger on 27.09.24.
//

import Foundation
import SwiftUI

struct HabitDetailView: View {
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $editedTitle)
                
                TextEditor(text: $editedNotes)
            }
            
            Section {
                VStack {
                    TimeProposalMenu(value: $editedTime)
                    
                    DatePicker("Time", selection: $editedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                }
            }
        }
        .formStyle(.grouped)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: presentDeleteCofirmationDialgo) {
                    Image(systemName: "trash")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: saveAction) {
                    Text("Save")
                }
                .disabled(haveValuesNoChanges)
            }
        }
        .confirmationDialog("Delete habit", isPresented: $isDeleteConfirmationDialogPresented) {
            Button(role: .destructive, action: deleteAction) {
                Text("Delete")
            }
        } message: {
            Text("Do you really want to delete the habit, you can`t undo it?")
        }
        .navigationTitle("Habit Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: onAppearAction)
    }
    
    //MARK: - View Model
    
    @Bindable var habit: Habit
    
    @Environment(\.dismiss) private var dismissAction
    @Environment(\.modelContext) private var modelContext
    @State private var isDeleteConfirmationDialogPresented = false
    @State private var editedTitle: String = ""
    @State private var editedNotes: String = ""
    @State private var editedTime: Date = .now
    
    private var haveValuesNoChanges: Bool {
        guard editedTitle == habit.title else { return false }
        guard editedNotes == habit.notes else { return false }
        let hour = Calendar.current.component(.hour, from: editedTime)
        let minute = Calendar.current.component(.minute, from: editedTime)
        guard hour == habit.hour else { return false }
        guard minute == habit.minute else { return false }
        return true
    }
    
    private func onAppearAction() {
        self.editedTitle = habit.title
        self.editedNotes = habit.notes
        self.editedTime = habit.time ?? .now
    }
    
    private func presentDeleteCofirmationDialgo() {
        isDeleteConfirmationDialogPresented.toggle()
    }
    
    private func deleteAction() {
        dismissAction()
        modelContext.delete(habit)
    }
    
    private func saveAction() {
        print("Save habit")
        let hour = Calendar.current.component(.hour, from: editedTime)
        let minute = Calendar.current.component(.minute, from: editedTime)
        
        habit.title = editedTitle
        habit.notes = editedNotes
        habit.hour = hour
        habit.minute = minute
    }
}
