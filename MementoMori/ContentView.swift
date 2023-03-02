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
                
                    ProgressView(progress: Double(lifeData.lifeTime.ageInDays) / Double(lifeData.lifeTime.lifeExpectancyInDays), accentColor: lifeData.lifeTime.accentColor)
                
                
                Text("Days left to live if you are so lucky:")
                    .font(.title2)
                    .padding(.top)
                DateTimerView(futureDate: lifeData.lifeTime.dateOfEndOfLife)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
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
                
                
                Spacer()
            }
            
            .padding()
            .navigationTitle("Your Life")
            
            .toolbar {
                Button(action: { presentOptions.toggle() }) { Label("Options", systemImage: "ellipsis.circle")}
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
