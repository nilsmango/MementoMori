//
//  Memento.swift
//  MementoMori
//
//  Created by Simon Lang on 27.02.23.
//

import SwiftUI

struct Memento: View {
    @Binding var lifeTime: LifeTime
    
    private let notifications = MementoNotifications()

    var body: some View {
        List {
            Toggle("Activate Mementos", isOn: $lifeTime.active)
                .onChange(of: lifeTime.active) { _ in

                    DispatchQueue.global().async {
                        notifications.scheduleMemento(active: lifeTime.active, mementoText: lifeTime.mementoText, quote: lifeTime.addRandomQuote, start: lifeTime.startMemento, end: lifeTime.endMemento, schedule: lifeTime.schedule)
                        
                        
                        
                    }
                    
                    lifeTime.mementoStatus = MementoStatus(active: lifeTime.active, schedule: lifeTime.schedule, startMemento: lifeTime.startMemento, endMemento: lifeTime.endMemento, mementoText: lifeTime.mementoText, addRandomQuote: lifeTime.addRandomQuote)
                }
            
            if lifeTime.active != false {
            
                VStack {
                    HStack {
                        Text("Random Memento Schedule")
                        Spacer()
                    }
                    
                    HStack {Picker("Random Memento Schedule", selection: $lifeTime.schedule) {
                        ForEach(MementoSchedule.allCases) { schedule in
                            if schedule != .twice {
                                Text(schedule.rawValue.capitalized)
                            } else {
                                Text("2 / Day")
                            }
                            
                        }
                    }.pickerStyle(.wheel)
                                        Picker("Start", selection: $lifeTime.startMemento){
                                            ForEach(4...23, id: \.self) { i in
                                                Text("\(i):00").tag(i)
                                                    .monospacedDigit()
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        Text("-")
                                        Picker("End", selection: $lifeTime.endMemento){
                                            ForEach(4...24, id: \.self) { i in
                                                Text("\(i):00").tag(i)
                                                    .monospacedDigit()
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                    }
                }
                
                
                
                // einige texte vorgeben, aber auch custom, wenn custom, dann textfiel zeigen.
                HStack {
                    Text("Custom Text:")
                    TextField("Memento Text", text: $lifeTime.mementoText)
                        .textFieldStyle(.roundedBorder)
                }
                
                
                Toggle("Add a Random Stoic Quote", isOn: $lifeTime.addRandomQuote)
                // Button mit Save (nur wenn was geändert, dann die schedules callen!), sonst "memento active"
            
            
            if lifeTime.mementoStatus == MementoStatus(active: lifeTime.active, schedule: lifeTime.schedule, startMemento: lifeTime.startMemento, endMemento: lifeTime.endMemento, mementoText: lifeTime.mementoText, addRandomQuote: lifeTime.addRandomQuote) {
                Label("Mementos are up to Date", systemImage: "checkmark")
                    .foregroundColor(.blue)
                } else {
                    Button(action: {
                        DispatchQueue.global().async {
                            notifications.scheduleMemento(active: lifeTime.active, mementoText: lifeTime.mementoText, quote: lifeTime.addRandomQuote, start: lifeTime.startMemento, end: lifeTime.endMemento, schedule: lifeTime.schedule)
                            
                        }
                        
                        lifeTime.mementoStatus = MementoStatus(active: lifeTime.active, schedule: lifeTime.schedule, startMemento: lifeTime.startMemento, endMemento: lifeTime.endMemento, mementoText: lifeTime.mementoText, addRandomQuote: lifeTime.addRandomQuote)
                    }) {
                        
                         Label("Tap to Update Mementos", systemImage: "arrow.counterclockwise")
                        }
                    
                }
            }
                
            
        }
        .navigationTitle("Memento")
        
    }
}

struct Reminder_Previews: PreviewProvider {
    static var previews: some View {
        Memento(lifeTime: .constant(LifeTime(active:true)))
    }
}
