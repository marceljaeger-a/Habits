//
//  ContentView.swift
//  Habits
//
//  Created by Marcel Jäger on 25.09.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack(path: $navManager.path) {
            HabitsListView()
                .navigationDestination(for: DetailHabitDestinationItem.self) { item in
                    HabitDetailView(habit: item.habit)
                }
                .navigationDestination(for: EditHabitDestinationItem.self) { item in
                    EditHabitView(habit: item.habit)
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: addNewHabitAction) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New habit")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                }
                .sheet(isPresented: $isAddHabitSheetPresented) {
                    AddHabitView()
                }
        }
        .onAppear(perform: addSampleData)
        .environment(navManager)
    }
    
    //MARK: - View Model
    
    @Environment(\.modelContext) private var modelContext
    @State private var navManager = NavigationManager()
    @State private var isAddHabitSheetPresented = false
    
    private func addNewHabitAction() {
        isAddHabitSheetPresented.toggle()
    }
    
    private func addSampleData() {
        let habit = Habit(title: "Laufe", notes: "", reward: "", hour: 6, symbole: .figureRun)
        modelContext.insert(habit)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
