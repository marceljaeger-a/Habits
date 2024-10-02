//
//  HabitSymbolePicker.swift
//  Habits
//
//  Created by Marcel Jäger on 30.09.24.
//

import Foundation
import SwiftUI

struct HabitSymbolePicker: View {
    var body: some View {
        HStack {
            Spacer()
            HabitSymboleView(value: value, font: .system(size: 92))
                .sensoryFeedback(.selection, trigger: value)
                .onTapGesture(perform: presentGallery)
            Spacer()
        }
        .sheet(isPresented: $isGalleryPresented) {
            HabitSymboleGallery(value: $value)
                .presentationDetents([.medium])
        }
    }
    
    @Binding var value: HabitSymbole
    
    @State private var isGalleryPresented = false
    
    private func presentGallery() {
        isGalleryPresented.toggle()
    }
}


struct HabitSymboleView: View {
    var body: some View {
        Image(systemName: value.rawValue)
            .symbolVariant(.circle.fill)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.primary, Color.accentColor)
            .font(font)
            .contentTransition(.symbolEffect(.replace))
    }
    
    let value: HabitSymbole
    let font: Font
}


struct HabitSymboleGallery: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Symbols")
                .font(.headline)
            
            LazyVGrid(columns: [
                .init(spacing: 10),
                .init(spacing: 10),
                .init(spacing: 10),
                .init(spacing: 10),
                .init(spacing: 10),
                .init(spacing: 10)
            ], spacing: 10) {
                ForEach(HabitSymbole.allCases.filter { $0 != value }, id: \.self) { symbole in
                    HabitSymboleView(value: symbole, font: .largeTitle)
                        .onTapGesture(perform: { select(symbole)})
                }
            }
            Spacer()
        }
        .padding()
    }
    
    @Binding var value: HabitSymbole
    
    @Environment(\.dismiss) private var dismissAction
    
    private func select(_ value: HabitSymbole) {
        self.value = value
        dismissAction()
    }
}
