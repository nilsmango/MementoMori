//
//  OptionsView.swift
//  MementoMori
//
//  Created by Simon Lang on 25.02.23.
//

import SwiftUI

struct OptionsView: View {
    
    @Binding var lifeTime: LifeTime
    
    @State private var colorPicker = false
    
    let columns = Array(repeating: GridItem(.fixed(25)), count: 6)
    
    private let notifications = MementoNotifications()
    
    var body: some View {
        List {
            Section("Your live") {
                DatePicker(
                    "Birthday",
                    selection: $lifeTime.birthDay,
                    displayedComponents: [.date, .hourAndMinute]
                )
                Stepper(value: $lifeTime.lifeExpectancyInYears, in: 35...120, step: 1) {
                    Text("Life Expectancy: \(lifeTime.lifeExpectancyInYears)")
                }
//                Picker("Time Division", selection: $lifeTime.timeScale) {
//                    ForEach(TimeScale.allCases) { division in
//                        Text(division.rawValue.capitalized)
//                    }
//                }
//                Picker("Graphic", selection: $lifeTime.graphic) {
//                    ForEach(PossibleGraphics.allCases) { graphic in
//                        Text(graphic.rawValue.capitalized)
//                    }
//                }
            }
           
            
            Section("Accent Color") {
                
                    LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(PossibleColors.allCases) { color in
                                
                                    Button(action: {
                                        lifeTime.accentColorSelection = color
                                        colorPicker = false
                                    }) {
                                        if lifeTime.accentColorSelection == color {
                                            Label(color.rawValue.capitalized, systemImage: "checkmark.circle.fill")
                                                                                        .labelStyle(.iconOnly)
                                                                                        .font(.title2)
                                                                                        .foregroundColor(lifeTime.getColor(selection: color))
                                            
                                        } else {
                                            Label(color.rawValue.capitalized, systemImage: "circle.fill")
                                                                                        .labelStyle(.iconOnly)
                                                                                        .font(.title2)
                                                                                        .foregroundColor(lifeTime.getColor(selection: color))
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                        }
            }
            
            Section("Mementos") {
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
                            
                             Label("Tap to update Mementos", systemImage: "arrow.counterclockwise")
                            }
                        
                    }
                }
            }
        }
        .headerProminence(.increased)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(lifeTime: .constant(LifeTime()))
    }
}
