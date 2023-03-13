//
//  MementoMoriWatchApp.swift
//  MementoMoriWatch Watch App
//
//  Created by Simon Lang on 11.03.23.
//

import SwiftUI

@main
struct MementoMoriWatch_Watch_AppApp: App {
    @StateObject private var watchLifeData = WatchLifeData()
    
    @AppStorage("lastCheckIn") var lastCheck = Date.now
    
    // because .inactive was also firing when becoming active I had to use this hack.
    @AppStorage("myHack") var canUpdateLastCheck = false
    
    @State var now = Date.now
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView(watchLifeData: watchLifeData, lastCheck: lastCheck, now: now)
                .accentColor(watchLifeData.lifeTime.accentColor)
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        if canUpdateLastCheck == true {
                            lastCheck = Date.now
                            canUpdateLastCheck = false
                        }
                        
                    } else if phase == .active {
                        watchLifeData.load()
                        now = Date.now
                        canUpdateLastCheck = true
                    }
                }
            
        }
    }
}
