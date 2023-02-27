//
//  Memento.swift
//  MementoMori
//
//  Created by Simon Lang on 27.02.23.
//

import SwiftUI

struct Memento: View {
    @State private var schedule: MementoSchedule = .daily
    
    @State private var startMemento: Int = 8
    
    @State private var endMemento: Int = 20

    @State private var mementoText: String = "Memento Mori!"
    
    @State private var addRandomQuote: Bool = false
    
    
    
    private let notifications = MementoNotifications()

    var body: some View {
        List {
            Picker("Random Memento Schedule", selection: $schedule) {
                ForEach(MementoSchedule.allCases) { schedule in
                    if schedule != .twice {
                        Text(schedule.rawValue.capitalized)
                    } else {
                        Text("Twice a Day")
                    }
                    
                }
            }
            if schedule != .never {
                Picker("Start", selection: $startMemento){
                    ForEach(4...20, id: \.self) { i in
                        Text("\(i):00").tag(i)
                            .monospacedDigit()
                    }
                }
                Picker("End", selection: $endMemento){
                    ForEach(4...24, id: \.self) { i in
                        Text("\(i):00").tag(i)
                            .monospacedDigit()
                    }
                }
                // einige texte vorgeben, aber auch custom, wenn custom, dann textfiel zeigen.
                HStack {
                    Text("Custom Text:")
                    TextField("Memento Text", text: $mementoText)
                }
                
                
                Toggle("Add a random stoic quote", isOn: $addRandomQuote)
                // Button mit Save (nur wenn was geändert, dann die schedules callen!), sonst "memento active"
                Button(action: {  }) {
                     Label("Start", systemImage: "ellipsis.circle")
                    }
            }
        }
        .navigationTitle("Memento")
        
    }
}

struct Reminder_Previews: PreviewProvider {
    static var previews: some View {
        Memento()
    }
}
