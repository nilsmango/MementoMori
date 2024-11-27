//
//  WatchOptionsView.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 13.03.23.
//

import SwiftUI

struct WatchOptionsView: View {
    
    @AppStorage("ImportFrom") var importFromPhone = false
    
    @Binding var lifeTime: LifeTime
    
    @State private var colorPicker = false
    
    let columns = Array(repeating: GridItem(.fixed(40)), count: 3)
    
    @State private var showingDatePicker = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //            formatter.timeStyle = .short
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    let iconCases = BottomIcon.allCases.filter( { $0 != .animatedHourglass })
    
    private let notifications = MementoNotifications()
    
    
    
    var body: some View {
        
//        NavigationView {
            List {
                // check if you actually have iPhone app, otherwise say, couldn't find iPhone companion app, please open the app there etc.
                Section("") {
                    Toggle("Sync to iPhone", isOn: $importFromPhone)
                        .onChange(of: importFromPhone) { _ in
                            
                            // sync to iPhone (auch das last time check in teil etc.
                            
                            
                        }
                }
                if importFromPhone == false {
                    
                    Section("Date of Birth") {
                        
                        Button(action: {
                            showingDatePicker = true
                        }, label: {
                            Text(dateFormatter.string(from: lifeTime.birthDay) + " " + timeFormatter.string(from: lifeTime.birthDay))
                            
                        })
                        .sheet(isPresented: $showingDatePicker, content: {
                            DateInputView(selection: $lifeTime.birthDay, presented: $showingDatePicker)
                        })
                        
                    }
                    
                    Section("Life Expectancy") {
                        Stepper(value: $lifeTime.lifeExpectancyInYears, in: 35...120, step: 1) {
                            Text("\(lifeTime.lifeExpectancyInYears) Years")
                                .font(.body)
                        }
                    }
                    Section("Icon") {
                        
                        Picker("Timer Icon", selection: $lifeTime.bottomIcon) {
                            ForEach(iconCases) { icon in
                                
                                Text(icon.rawValue.capitalized)
                                
                            }
                        }
                    }
                    Section("Time Lost") {
                        Toggle("Show Last Check-In", isOn: $lifeTime.lastCheckActive)
                        
                        //                Picker("Graphic", selection: $lifeTime.graphic) {
                        //                    ForEach(PossibleGraphics.allCases) { graphic in
                        //                        Text(graphic.rawValue.capitalized)
                        //                    }
                        //                }
                        
                    }
                    
                    Section("Accent Color") {
                        
                        LazyVGrid(columns: columns, spacing: 12) {
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
                        .padding(.vertical, 15)
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
                            
                            
                            
                            Picker("Random Memento Schedule", selection: $lifeTime.schedule) {
                                ForEach(MementoSchedule.allCases) { schedule in
                                    if schedule != .twice {
                                        Text(schedule.rawValue.capitalized)
                                    } else {
                                        Text("2 / Day")
                                    }
                                    
                                }
                            }
                            Picker("Start", selection: $lifeTime.startMemento){
                                ForEach(4...23, id: \.self) { i in
                                    Text("\(i):00").tag(i)
                                        .monospacedDigit()
                                }
                            }
                            
                            Picker("End", selection: $lifeTime.endMemento){
                                ForEach(4...24, id: \.self) { i in
                                    Text("\(i):00").tag(i)
                                        .monospacedDigit()
                                }
                            }
                            
                            
                            
                        
                            VStack(alignment: .leading) {
                            
                                Text("Custom Text")
                                    .padding(.bottom, -20)
                                    .padding(.top, 5)
                            
                                TextField("Memento Text", text: $lifeTime.mementoText)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.bottom, -10)
                                
                                
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
        }
    }
}

struct WatchOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchOptionsView(lifeTime: .constant(LifeTime(active: true)))
    }
}
