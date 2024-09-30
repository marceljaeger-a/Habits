//
//  AddHabitView.swift
//  Habits
//
//  Created by Marcel Jäger on 27.09.24.
//

import Foundation
import SwiftUI

struct AddHabitView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .focused($focusedControl, equals: .titleTextField)
                }
                
                Section("Notes & Reward") {
                    TextEditor(text: $notes)
                        .focused($focusedControl, equals: .notesTextEditor)
                    
                    TextField("Reward", text: $reward)
                }
               
                Section("Time") {
                    VStack {
                        TimeProposalMenu(value: $time)
                        
                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .defaultFocus($focusedControl, .titleTextField, priority: .automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: cancelAction){
                        Text("Cancel")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: saveAction){
                        Text("Save")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
                }
            }
        }
        .onAppear(perform: onAppearAction)
    }
    
    //MARK: - View Model
    private enum FocuedControl {
        case titleTextField
        case notesTextEditor
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismissAction
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var reward: String = ""
    @State private var time: Date = (Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now) ?? .now)
    @FocusState private var focusedControl: FocuedControl?
    
    private func onAppearAction() {
        focusedControl = .titleTextField
    }
    
    private func cancelAction() {
        dismissAction()
    }
    
    private func saveAction() {
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        
        print("Add new habit")
        let habit = Habit(title: title, notes: notes, reward: reward, hour: hour, minute: minute, symbole: "tree")
        modelContext.insert(habit)
        dismissAction()
    }
}
