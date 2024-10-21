//
//  HabitDetailView.swift
//  Habits
//
//  Created by Marcel Jäger on 27.09.24.
//

import Foundation
import SwiftUI

struct EditHabitView: View {
    var body: some View {
        Form {            
            Section {
                VStack(spacing: 25) {
                    HabitSymbolePicker(value: $editedSymbole)
                    
                    TextField("Title", text: $editedTitle)
                        .focused($focusedControl, equals: .titleTextField)
                        .font(.title3.bold())
                        .padding()
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
                }
                .padding(.vertical, 5)
            }
            
            Section {
                TextEditor(text: $editedNotes)
                    .overlay(alignment: .topLeading) {
                        if focusedControl != .notesTextEditor && editedNotes.isEmpty {
                            Text("Notes")
                                .foregroundStyle(.tertiary)
                                .padding(.vertical, 5)
                        }
                    }
                    .focused($focusedControl, equals: .notesTextEditor)
            }
           
            Section {
                VStack {
                    TimeProposalMenu(value: $editedTime)
                    
                    DatePicker("", selection: $editedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                }
                .padding(.vertical, 5)
            }
            
            Section {
                TextField("Reward", text: $editedReward)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Edit habit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: presentDeleteCofirmationDialgo) {
                    Image(systemName: "trash")
                }
                .tint(.red)
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
        .onAppear(perform: onAppearAction)
    }
    
    //MARK: - View Model
    private enum FocuedControl {
        case titleTextField
        case notesTextEditor
    }
    
    @Bindable var habit: Habit
    
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationManager.self) private var navManager
    @Environment(\.noticifationService) private var notificationService
    @State private var isDeleteConfirmationDialogPresented = false
    @State private var editedSymbole: HabitSymbole = .figureWalk
    @State private var editedTitle: String = ""
    @State private var editedNotes: String = ""
    @State private var editedReward: String = ""
    @State private var editedTime: Date = .now
    @FocusState private var focusedControl: FocuedControl?
    
    private var haveValuesNoChanges: Bool {
        guard editedSymbole == habit.symbole else { return false }
        guard editedTitle == habit.title else { return false }
        guard editedNotes == habit.notes else { return false }
        guard editedReward == habit.reward else { return false }
        let hour = Calendar.current.component(.hour, from: editedTime)
        let minute = Calendar.current.component(.minute, from: editedTime)
        guard hour == habit.hour else { return false }
        guard minute == habit.minute else { return false }
        return true
    }
    
    private func onAppearAction() {
        self.editedSymbole = habit.symbole
        self.editedTitle = habit.title
        self.editedNotes = habit.notes
        self.editedReward = habit.reward
        self.editedTime = habit.time ?? .now
    }
    
    private func presentDeleteCofirmationDialgo() {
        isDeleteConfirmationDialogPresented.toggle()
    }
    
    private func deleteAction() {
        UserNotificationFunctions.removeNotificationsOfHabit(habit, notificationService: notificationService)
        modelContext.delete(habit)
        for _ in 0..<navManager.path.count {
            navManager.path.removeLast()
        }
    }
    
    private func saveAction() {
        print("Save habit")
        let hour = Calendar.current.component(.hour, from: editedTime)
        let minute = Calendar.current.component(.minute, from: editedTime)
        
        habit.symbole = editedSymbole
        habit.title = editedTitle
        habit.notes = editedNotes
        habit.hour = hour
        habit.minute = minute
        
        UserNotificationFunctions.addNotificationOfHabitForTommorow(habit, notificationService: notificationService)
    }
}


#Preview {
    EditHabitView(habit: .init(title: "", notes: "", reward: "", hour: 2, symbole: .bicycle))
}
