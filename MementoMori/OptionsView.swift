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
                Picker("Time Division", selection: $lifeTime.timeScale) {
                    ForEach(TimeScale.allCases) { division in
                        Text(division.rawValue.capitalized)
                    }
                }
                Picker("Graphic", selection: $lifeTime.graphic) {
                    ForEach(PossibleGraphics.allCases) { graphic in
                        Text(graphic.rawValue.capitalized)
                    }
                }
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
            
        }
        .headerProminence(.increased)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(lifeTime: .constant(LifeTime()))
    }
}
