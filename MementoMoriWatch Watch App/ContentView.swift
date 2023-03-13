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
                        .padding(.top, -25)
                        .padding(.bottom,-5)
                    Divider()
                    Text("Days left to live if you are so lucky:")
                        .font(.caption2)
                        .padding(.vertical)
                    DateTimerView(futureDate: watchLifeTime.dateOfEndOfLife)
                    Text(watchLifeTime.dateOfEndOfLife, style: .timer)
//                        .font(.headline)
//                        .fontWeight(.bold)
                        .padding(.bottom)
                    Divider()
                    
                    if watchLifeTime.bottomIcon != .none {
                        ZStack {
                            Image(watchLifeTime.iconString)
                                .resizable()
                                .scaledToFit()
                            
                            if watchLifeTime.bottomIcon == .animatedHourglass {
                                SpriteView(scene: Sandfall(), options: [.allowsTransparency])
                                SpriteView(scene: SandScatter(), options: [.allowsTransparency])
                            }
                        }
                        .frame(height: 50)
                        .padding(.vertical)
                    }
                        
                        
                    Divider()
                    
                    if watchLifeTime.active {
                        Label("Mementos active", systemImage: "checkmark")
                            .padding(.vertical)
                    } else {
                        Label("No Mementos active", systemImage: "xmark")
                            .padding(.vertical)
                    }
              
                    Divider()
                    
                    NavigationLink(destination: {
                        WatchOptionsView(lifeTime: watchLifeData.$lifeTime)
                    }, label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                    )
                    
                    
                }
                .padding(.horizontal)
                
            }
            .navigationTitle("Your Life")
                    
                        
                }
            
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(watchLifeData: WatchLifeData(), lastCheck: Date.init(timeIntervalSinceNow: -43322), now: Date.now)
    }
}
