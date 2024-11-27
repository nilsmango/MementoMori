//
//  ContentView.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 11.03.23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @ObservedObject var watchLifeData: WatchLifeData
    
    @AppStorage("firstTimeActive") var firstTime = true
    
    @State private var showingOptions = false
    
    var lastCheck: Date
    var now: Date
    
    // "Alias" so you don't have to write lifeData.lifeTime each time
    private var watchLifeTime: LifeTime {
        return watchLifeData.lifeTime
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CustomProgressView(progress: Double(watchLifeTime.ageInDays) / Double(watchLifeTime.lifeExpectancyInDays), accentColor: watchLifeTime.accentColor, largeDesign: false)
                        .padding(.top, -20)
                        .padding(.bottom,-5)
                    
                    Divider()
                    
                    Text("Days left to live if you are so lucky".uppercased())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    HStack(alignment: .center) {
                        if watchLifeTime.bottomIcon != .none {
                        
                            Image(watchLifeTime.iconString)
                                .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                    .padding(.top, -7)
                            
                        }
                        
                        DateTimerView(futureDate: watchLifeTime.dateOfEndOfLife)
                            .font(.title3)
                            .padding(.bottom)
                            .padding(.top, watchLifeTime.bottomIcon != .none ? 0 : 2)
                        
                        
                    }
                    
                    if watchLifeTime.lastCheckActive {
                        Divider()
                        Text(dateToDateFormatted(from: lastCheck, to: now).hasDays ? "Days lost since your last check-in".uppercased() : "Time lost since your last check-in".uppercased())
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    Text(dateToDateFormatted(from: lastCheck, to: now).string)
                            .font(.title3)
                            .padding(.bottom)
                            .padding(.top, 2)
                        
                    }
                    
                    Divider()
                                        
                    if watchLifeTime.active {
                        Label("Mementos active", systemImage: "checkmark")
                            .padding(.vertical)
                            .font(.footnote)
                    } else {
                        Label("No Mementos active", systemImage: "xmark")
                            .padding(.vertical)
                            .font(.footnote)
                    }
                    
              
                    Button(action: {
                        showingOptions = true
                    }) { Label("Options", systemImage: "ellipsis.circle") }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.background)
                        .tint(watchLifeData.lifeTime.accentColor)
                        .padding(.top)
                    
                    
                        .sheet(isPresented: $showingOptions, content: {
                            WatchOptionsView(lifeTime: $watchLifeData.lifeTime)
                                .navigationTitle("Options")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                  ToolbarItem(placement: .confirmationAction) {
                                      Button(action: {
                                          showingOptions = false
                                          watchLifeData.save()
                                      }
                                          ) {
                                      Text("Done")
                                              .foregroundColor(watchLifeData.lifeTime.accentColor)
                                    }
                                          
                                  }
                                }
                        })

                }
                .padding(.horizontal)
                
            }
            .navigationTitle("Your Life")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if firstTime == true {
                    showingOptions = true
                    firstTime = false
                }
            }
                        
                }
            
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(watchLifeData: WatchLifeData(), lastCheck: Date.init(timeIntervalSinceNow: -43322), now: Date.now)
    }
}
