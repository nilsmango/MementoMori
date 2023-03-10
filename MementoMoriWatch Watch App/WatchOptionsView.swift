//
//  WatchOptionsView.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 13.03.23.
//

import SwiftUI

struct WatchOptionsView: View {
    
    @Binding var lifeTime: LifeTime
    
    @State private var colorPicker = false
    
    let columns = Array(repeating: GridItem(.fixed(25)), count: 6)
    
    private let notifications = MementoNotifications()
    
    @AppStorage("ImportFrom") var importFromPhone = false
    
    var body: some View {
        
        NavigationView {
            List {
                // check if you actually have iPhone app, otherwise say, couldn't find iPhone companion app, please open the app there etc.
                Section("Import from iPhone") {
                    Toggle("Import from iPhone", isOn: $importFromPhone)
                        .onChange(of: importFromPhone) { _ in
                            
                            // import from iPhone
                                
                            
                        }
                            }
                if importFromPhone == false {
                    
                    Section("Your live") {
                        DatePicker(
                            "Birthday",
                            selection: $lifeTime.birthDay,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        Stepper(value: $lifeTime.lifeExpectancyInYears, in: 35...120, step: 1) {
                            Text("Life Expectancy: \(lifeTime.lifeExpectancyInYears)")
                        }
                        Picker("Bottom Icon", selection: $lifeTime.bottomIcon) {
                            ForEach(BottomIcon.allCases) { icon in
                                if icon == .animatedHourglass {
                                    Text("Hourglass 2")
                                } else {
                                    Text(icon.rawValue.capitalized)
                                }
                                
                            }
                        }
                        
                        Toggle("Show Last Check-In", isOn: $lifeTime.lastCheckActive)
                        
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
//                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            
                            Toggle("Add a Random Stoic Quote", isOn: $lifeTime.addRandomQuote)
                            // Button mit Save (nur wenn was ge??ndert, dann die schedules callen!), sonst "memento active"
                        
                        
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
            }
        }
    }
}

struct WatchOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchOptionsView(lifeTime: .constant(LifeTime()))
    }
}
