//
//  ContentView.swift
//  MementoMori
//
//  Created by Simon Lang on 22.02.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var lifeData: LifeData
    
    
    @State private var presentOptions = false
        
    var body: some View {
        NavigationView {
            VStack {
                
                switch lifeData.lifeTime.timeScale {
                case .years:
                    Text("With a life expectancy of \(lifeData.lifeTime.lifeExpectancyInYears) years you have \(lifeData.lifeTime.yearsUntilDeath) years left to live, if you are so lucky.")
                case .months:
                    Text("With a life expectancy of \(lifeData.lifeTime.lifeExpectancyInMonths) months you have \(lifeData.lifeTime.monthsUntilDeath) months left to live, if you are so lucky.")
                case .weeks:
                    Text("With a life expectancy of \(lifeData.lifeTime.lifeExpectancyInWeeks) weeks you have \(lifeData.lifeTime.weeksUntilDeath) weeks left to live, if you are so lucky.")
                case .days:
                    Text("With a life expectancy of \(lifeData.lifeTime.lifeExpectancyInDays) days you have \(lifeData.lifeTime.daysUntilDeath) days left to live, if you are so lucky.")
                }
                
                NavigationLink {
                    
                    Memento(lifeTime: $lifeData.lifeTime)
                            
                  
                    
                } label: {
                    Label("Life Memento", systemImage: "folder")
                }
                .buttonStyle(.borderedProminent)
                
                
                Button(action: { presentOptions = true }) {
                    Label("App Mindfulness Shortcuts", systemImage: "ellipsis.circle")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: { presentOptions = true }) {
                    Label("Widget Previews", systemImage: "ellipsis.circle")
                }
                .buttonStyle(.borderedProminent)
                
                switch lifeData.lifeTime.graphic {
                case .dots:
                    DotsView(timeScale: lifeData.lifeTime.timeScale.rawValue.capitalized, columns: lifeData.lifeTime.columns, spacing: lifeData.lifeTime.spacing, numberOfDots: {
                        switch lifeData.lifeTime.timeScale {
            case .years:
                return lifeData.lifeTime.lifeExpectancyInYears
            default:
                return lifeData.lifeTime.lifeExpectancyInDays
            }
                    }()
                                
                                , alreadyLived: lifeData.lifeTime.ageInYears, color: lifeData.lifeTime.accentColor, framing: lifeData.lifeTime.framing)
                case .progress:
                    ProgressView(progress: Double(lifeData.lifeTime.ageInDays) / Double(lifeData.lifeTime.lifeExpectancyInDays), accentColor: lifeData.lifeTime.accentColor)
                }
                Spacer()
            }
            
            .padding()
            .navigationTitle("Your Life")
            
            .toolbar {
                Button(action: { presentOptions = true }) { Label("Options", systemImage: "ellipsis.circle")}
            }
            .sheet(isPresented: $presentOptions) {
                NavigationView {
                    OptionsView(lifeTime: $lifeData.lifeTime)
                        .navigationTitle("Options")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { presentOptions = false }) { Label("Dismiss", systemImage: "x.circle.fill")}
                                }
                            }
                        
                }
                .accentColor(lifeData.lifeTime.accentColor)
            }
            .accentColor(lifeData.lifeTime.accentColor)
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(lifeData: LifeData())
                }
}
