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
                    VStack(spacing: 25) {
                        HabitSymbolePicker(value: $symbole)
                        
                        TextField("Title", text: $title)
                            .focused($focusedControl, equals: .titleTextField)
                            .font(.title3.bold())
                            .padding()
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
                    }
                    .padding(.vertical, 5)
                }
                
                Section {
                    TextEditor(text: $notes)
                        .overlay(alignment: .topLeading) {
                            if focusedControl != .notesTextEditor && notes.isEmpty {
                                Text("Notes")
                                    .foregroundStyle(.tertiary)
                                    .padding(.vertical, 5)
                            }
                        }
                        .focused($focusedControl, equals: .notesTextEditor)
                }
               
                Section {
                    VStack {
                        TimeProposalMenu(value: $time)
                        
                        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                    .padding(.vertical, 5)
                }
                
                Section {
                    TextField("Reward", text: $reward)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("New habit")
            .navigationBarTitleDisplayMode(.inline)
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
        .task {
            if await notificationService.hasAuthorization() == false {
                do {
                    try await notificationService.requestAuthorization()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //MARK: - View Model
    private enum FocuedControl {
        case titleTextField
        case notesTextEditor
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismissAction
    @Environment(\.noticifationService) private var notificationService
    @State private var symbole: HabitSymbole = .figureWalk
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
        let habit = Habit(title: title, notes: notes, reward: reward, hour: hour, minute: minute, symbole: symbole)
        modelContext.insert(habit)
        do {
            try modelContext.save()
            UserNotificationFunctions.addNotificationOfHabitForTommorow(habit, notificationService: notificationService)
        } catch {
            print(error)
        }
        dismissAction()
    }
}


#Preview {
    AddHabitView()
}
